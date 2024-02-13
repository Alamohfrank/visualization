# Intro Skills Activity {#introactivity}
## Problem 1

Load the tidyverse and lubridate libraries.

Read in the PINE_NFDR_Jan-Mar_2010 csv using read_csv()

Make a plot with the date on the x axis, discharge on the y axis. Show the discharge of the two watersheds as a line, coloring by watershed (StationID)

```{r}
library(tidyverse)
library(lubridate)
SNP<- read_csv("PINE_NFDR_Jan-Mar_2010.csv")
# Plot 1: Plotting The Hydrograph

SNP |>
  ggplot(aes(datetime,cfs))+
  geom_line(aes(color=StationID))+
  labs(title="plot 1: Hydrograph", x=NULL, y= "Discharge (cfs)")+
  theme_classic()+
  theme(plot.title = element_text(hjust=0.5))
```

## Problem 2

Make a boxplot to compare the discharge of Pine to NFDR for February 2010.

Hint: use the pipe operator and the filter() function.

Hint2: when you filter dates, you have to let R know you're giving it a date. You can do this by using the mdy() function from lubridate.

```{r}
#Extract February 2010 Dataset
SNP_Feb <- SNP |>
   filter(month==2)
#plot 2: February Discharge Boxplots"
   SNP_Feb |>
   ggplot()+
   geom_boxplot(aes(StationID,cfs))+
   labs(title="plot 2: February Discharge Boxplots", y="Discharge (cfs)")+
   theme_classic()+
   theme(plot.title=element_text(hjust=0.5))
```

## Problem 3

Read in the Flashy Dat Subset file.

For only sites in ME, NH, and VT: Plot PET (Potential Evapotranspiration) on the X axis and RBI (flashiness index) on the Y axis. Color the points based on what state they are in. Use the classic ggplot theme.

```{r}
#Extract ME, NH, and VT Dataset
Flashy <- read_csv("Flashy_Dat_Subset.csv")
States<-c("ME", "NH", "VT")
Flashy2<- Flashy |>
  filter(STATE %in% States) # To crosscheck if value of state is one listed in the states

#plot 3: To plot PET Against RBI
Flashy2 |>
  ggplot()+
  geom_point(aes(PET, RBI, color=STATE))+
  labs(title="plot 3:PET vs. RBI")+
  theme_classic()+
  theme(plot.title = element_text(hjust=0.5))
```

## Problem 4

We want to look at the amount of snow for each site in the flashy dataset. Problem is, we are only given the average amount of total precip (PPTAVG_BASIN) and the percentage of snow (SNOW_PCT_PRECIP).

Create a new column in the dataset called SNOW_AVG_BASIN and make it equal to the average total precip times the percentage of snow (careful with the percentage number).

Make a barplot showing the amount of snow for each site in Maine. Put station name on the x axis and snow amount on the y. You have to add something to geom_bar() to use it for a 2 variable plot... check out the ggplot cheatsheet or do a quick internet search.

The x axis of the resulting plot looks terrible! Can you figure out how to rotate the X axis labels so we can read them?

```{r}
#To Load Dataset and Create Column for Snow Amount
Flashy<-read_csv("Flashy_Dat_Subset.csv")
Flashy_Snow <- Flashy |>
  mutate(SNOW_AVG_BASIN = PPTAVG_BASIN * (SNOW_PCT_PRECIP/100))

#PLOT4:  To Plot Snow in Maine
Flashy_ME <- Flashy_Snow |>
  filter(STATE=="ME") # This is to select only Maine Data

Flashy_ME |>
  ggplot()+
  geom_col(aes(x=STANAME, y =SNOW_AVG_BASIN))+
  labs(title="plot 4: Average Snowfall in Maine", x="Station", y="Snowfall")+
  theme_classic()+
  theme(plot.title = element_text(hjust=0.5))+
  theme(axis.text.x=element_text(angle=90, vjust=0.5, hjust=1, size=6))

```

## Problem 5

Create a new tibble that contains the min, max, and mean PET for each state. Sort the tibble by mean PET from high to low. Give your columns meaningful names within the summarize function or using rename().

Be sure your code outputs the tibble.

```{r}
#Load Dataset
Flashy <- read.csv("Flashy_Dat_Subset.csv")
#Create new tibble
Flashy_PET <- Flashy |>
  group_by(STATE) |> 
  summarise(PET_Mean=mean(PET), PET_Max=max(PET),PET_Min=min(PET)) |>
  arrange(desc(PET_Mean))
print(Flashy_PET)

```

## Problem 6

Take the tibble from problem 5. Create a new column that is the Range of the PET (max PET - min PET). Then get rid of the max PET and min PET columns so the tibble just has columns for State, mean PET, and PET range.

Be sure your code outputs the tibble.

```{r}
#create new Tribble
Flashy_PET2 <- Flashy_PET |>
  mutate(PET_Range = PET_Max - PET_Min) |>
  select(!c(PET_Max, PET_Min))
print(Flashy_PET2)

```
