# Workshop Impact By Year

In this directory we attempt to analyze the impact that workshops given in different
years have had on schools that have benefited from them. In this directory you can find:
* An R script to transform the school data set to a long format.
* An example of an open office spreadsheet that shows the data in a table,
  highlighting a workshop with positive effects and another with negative
  effects.
* Still to come: a statistical analysis of positive and negative effects.

## Long data format
This script reads in the school data set and transforms the data to long format.
The resulting file contains data from schools that have evaluations all four
years (that is about 50% of schools). Each data row contains a school data point
for a single year. The row data should be self-explanatory, unfortunately the R
code is not.

To run it put the school data in the same directory as the script and run:

    $ Rscript long_format.R

## Pivot table
In order to create the pivot table:
* Go to Insert, Sheet from File, select the long format csv.
  Select the right separator (comma).
* Now select the data that you just loaded.
* Go to Data, Pivot Table, Create, click on OK to use current selection.
* Choose the fields you are interested in. In our case we want to:
  * put the year in column fields,
  * put `y.ws` in row, this is the number of years of most recent
    workshop (0 means no workshop so far)
  * select `schoolcode` to Data fields and click Options to change
    aggregation to count. This field will be useful to know how many
    schools have had the most recent workshop X years ago for a given
    year.
  * now add `average_marks` to Data Fields, again click options to change
    the aggregation to average. Now you can see the average grade of schools.
  * it's interesting to add `delta_average_marks` which shows the change
    between last year and the current year of average_marks for that group of
    schools. Remember to switch the aggregation to average.
  * let's also add `pass_ratio` and `delta_pass_rate` it should really be
    ratio in the latter one but I made a typo.

Make sure to scroll all the way down to see the pivot table. You might need
to resize columns to read the numbers fully. Also I have changed the formatting
of cells to only show two decimal places. I have also added coloring to show
the following interesting patterns that the table reveals:
* The roughly 141 schools that received a workshop in 2011 have an average mark
  that is consistently higher than the marks of schools without a treatement that
  year. This higher average mark is highlighted in green.
* Note that the above also holds for the pass ration so I have highlighted
  it as well.
* Another interesting pattern is that 65 schools that received a treatment
  in 2013 perform worse than the group without treatment. I have highlighted
  that in red.
* The reference (no treatment) average marks and pass ratio are highlighted in blue.
* Note that there are other groups of schools that have a positive effect on
  treatment but I have not highlighted them, homework for the reader :).
* In order to somehow control for selection bias (the good performance of
  year 2011 might be due to having selected schools with teachers that were
  already motivated to start with) I have added the increase in average marks
  accross year boundaries (`delta_average_marks`). However, the real way
  to avoid selection bias is random assignment.

## A statistical analysis of positive effects (2011 group) and negative effects (2013 group)
I attempted to establish statistical significance of the positive and negative examples
that I mentioned above. For this I performed regression separately for each target year.
These regressions gave significance to the examples I gave. However the R-squared is very
low (due to variance between schools). I will try to improve on this analysis and commit
it hopefully soon.

--Alexey
