
sch.df <- read.csv("SchoolLevel.csv", sep=";")
# The number of yearly marks that a school has.
sch.df$sum_year_marks <- (ifelse(is.na(sch.df$Average_Marks_2014),0,1)+ifelse(is.na(sch.df$Average_Marks_2013),0,1)+ifelse(is.na(sch.df$Average_Marks_2012),0,1)+ifelse(is.na(sch.df$Average_Marks_2011),0,1))

# Compute the sum of columns "input"+ws up to year y (not specified the years in ws)
summcol <- function(df, ws, input, output) {
  if(length(ws)==0) {
    df[,output] <- 0
  } else if(length(ws)==1) {
    df[,output] <- sch.df.cl[,paste(input,ws,sep="")]
  } else {
    df[,output] <- rowSums(sch.df.cl[,paste(input,ws,sep="")])
  }
  df
}

# Compute the number of years of the closest workshop to each school
# for the year y
mincol <- function(y, df, ws, input, output) {
  if(length(ws)==0) {
    df[,output] <- 0
  } else if(length(ws)==1) {
    df[,output] <- (sch.df.cl[,paste(input,ws,sep="")] >= 1) * (y - ws)
  } else {
    m <- sch.df.cl[,paste(input,ws,sep="")]>=1
    m <- sweep(m, MARGIN=2, (y-ws), `*`)
    df[,output] <- apply(m, 1, function(xs){if(length(xs[xs>0])==0) 0 else min(xs[xs>0])})
  }
  df
}


# Compute long format dataframe
########################
sch <- data.frame()
years <- seq(2011,2014)
dyears <- seq(2010,2014)
# Only include schools that have average marks for all four years
sch.df.cl <- sch.df[sch.df$sum_year_marks==4,]
for (y in years) {
  df <- data.frame(schoolcode=sch.df.cl$schoolcode,
                   year=y,
                   average_marks=sch.df.cl[,paste("Average_Marks_", y, sep="")],
                   candidates=sch.df.cl[,paste("Candidates_", y, sep="")],
                   passed=sch.df.cl[,paste("Passed_", y, sep="")],
                   ws=sch.df.cl$SUM.WORKSHOPS
  )
  df <- summcol(df, dyears[dyears < y], "WS.", "num.ws")
  df$same_y.ws <- sch.df.cl[,paste("WS.",y,sep="")] >= 1
  df <- mincol(y, df, dyears[dyears < y], "WS.", "y.ws")
  df <- summcol(df, dyears[dyears>=2012 & dyears<y], "Bonanza_", "num.bonanza")
  df <- mincol(y, df, dyears[dyears>=2012 & dyears<y], "Bonanza_", "y.bonanza")
  df <- summcol(df, dyears[dyears>=2013 & dyears<y], "Project_", "num.project")
  df <- mincol(y, df, dyears[dyears>=2013 & dyears<y], "Project_", "y.project")
  if(y>2011) {
    df$delta_average_marks <- sch.df.cl[,paste("Average_Marks_", y, sep="")] - sch.df.cl[,paste("Average_Marks_", y-1, sep="")]
  } else {
    df$delta_average_marks <- 0
  }
  if(y>2011) {
    df$delta_pass_rate <- sch.df.cl[,paste("Passed_", y, sep="")] / sch.df.cl[,paste("Candidates_", y, sep="")] - sch.df.cl[,paste("Passed_", y-1, sep="")] / sch.df.cl[,paste("Candidates_", y-1, sep="")]
  } else {
    df$delta_pass_rate <- 0
  }
  sch <- rbind(sch, df)
}
sch$pass_ratio <- sch$passed / sch$candidates
sch$has_ws <- sch$num.ws > 1

write.csv(sch, "SchoolLevel_long.csv", sep=";")

