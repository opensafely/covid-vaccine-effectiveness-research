write.csv(installed.packages()[, c("Package","Version")], row.names=FALSE, file="output/available_packages.csv")


print(Sys.getenv("BACKEND"))
