import pandas as pd
import numpy as np
   
    
def eventcountdf(event_dates, date_range, rule='D', popadjust=False):
    # to calculate the daily count for events recorded in a dataframe
    # where event_dates is a dataframe of date columns
    # set popadjust = 1000, say, to report counts per 1000 population
    
    # initialise dataset
    counts = date_range
    
    
    for col in event_dates:

        # Creates a series of the entry date of the index event
        in_date = event_dates.loc[:, col]

        counts = counts.join(
            pd.DataFrame(in_date, columns=[col]).groupby(col)[col].count().to_frame()
        )

    # convert nan to zero
    counts = counts.fillna(0)
    
    if rule != "D":
        counts = counts.resample(rule).sum()
    
    if popadjust is not False:
        pop = event_dates.shape[0]
        poppern = pop/popadjust
        counts = counts.transform(lambda x: x/poppern)
    
    return(counts)
   


def eventcountseries(event_dates, date_range, rule='D', popadjust=False):
    # to calculate the daily count for events recorded in a series
    # where event_dates is a series
    # set popadjust = 1000, say, to report counts per 1000 population
    
    pop = event_dates.size
    
    counts = event_dates.value_counts().reindex(date_range.index, fill_value=0)
        
    if rule != "D":
        counts = counts.resample(rule).sum()
    
    if popadjust is not False:
        pop = event_dates.size
        poppern= pop/popadjust
        counts = counts.transform(lambda x: x/poppern)
    
    return(counts)







def timetoevent(df, origindate, eventdate, censordate):
    # takes a dataframe (df) with columns (origindate, eventdate, censordate)
    # and outputs censored time to event series
        
    data = df[[origindate, eventdate, censordate]]
    data1 = data

    data1['date'] = data[eventdate]
    data1['censor_date'] = data[censordate]
    data1['date'] = data1['date'].where(data1['date'] > data1['censor_date'], data1['censor_date'])
    data1['origin_date'] = data[origindate]
    data1['indicator'] = np.where((data1['date']<=data1['censor_date']), 1, 0)
    data1['time'] = (data1['date'] - data1['origin_date']).astype('timedelta64[D]')

    return data1["date"], data1["time"], data1["indicator"]


def KMestimate(time, indicator):   

    ## function that takes event times (=time, a series) and a censor indicator (=indicator, a series taking values 1=event, 0=censor)
    ## and produces kaplan meier estimates in a dataframe

    time = np.array(time)
    indicator = np.array(indicator)
    sortinds = time.argsort()
    time = time[sortinds]
    indicators = indicator[sortinds]

    min_time = 0
    max_time = time.max()
    atrisk0 = len(time)

    unq_times, count = np.unique(time, return_counts=True)
    event_time, event_count = np.unique(time[indicator==1], return_counts=True)
    censor_time, censor_count = np.unique(time[indicator==0], return_counts=True)
    
    cml_count = count.cumsum()
    atrisk = (atrisk0-cml_count) + count

    kmdata = pd.DataFrame({
        'time': unq_times, 
        'atrisk': atrisk
    }).merge(
        pd.DataFrame({
            'time': event_time, 
            'n_events': event_count
        }), on="time", how='left'
    ).merge(
        pd.DataFrame({
            'time': censor_time, 
            'censored': censor_count
        }), on="time", how='left'
    )

    kmdata[['n_events','censored']] = kmdata[['n_events','censored']].fillna(0)
    
    
    kmdata['kmestimate'] = 1
    for i in kmdata.index:
        if i==0:
            kmdata.loc[i, 'kmestimate'] = 1 * (kmdata.loc[i, 'atrisk'] - kmdata.loc[i, 'n_events'])/kmdata.loc[i, 'atrisk']
        else:
            kmdata.loc[i, 'kmestimate'] = kmdata.loc[i-1, 'kmestimate'] * (kmdata.loc[i, 'atrisk'] - kmdata.loc[i, 'n_events'])/kmdata.loc[i, 'atrisk']

    return kmdata


def KMestimategroup(df, time, indicator, group):
    # takes a dataframe (df) with columns (time, indicator, group)
    # and outputs km esimates from KMestimate function, by group
        
    groups = df[group].unique()
    
    kmdata = pd.DataFrame(columns=[group, "time", "atrisk", "n_events", "kmestimate"])
    
    for g in groups:
        data_group = df[df[group]==g]
        kmdata_group = KMestimate(data_group[time], data_group[indicator])
        kmdata_group[group] = g
        
        kmdata = kmdata.append(kmdata_group, ignore_index=True)
    
    return kmdata