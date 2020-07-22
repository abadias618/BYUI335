---
title: "Try2, Same as Task 13, but with Functions"
author: "A. Abdias Baldiviezo"
date: "June 10, 2020"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: show
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---






```r
# Use this R-Chunk to import all your datasets!
rand_letters <- read_lines("https://byuistats.github.io/M335/data/randomletters.txt")
rand_numbers_and_letters <- read_lines("https://byuistats.github.io/M335/data/randomletters_wnumbers.txt")
```

## Background

We will continue to build on the previous task 13, but this time try to automate the task and make the code more re-usable. Go back to the previous task and build your code into two or three functions that performs the same work for the tasks. 

    Your functions can allow the input of the spacing between characters or maybe a vector that picks of specific characters.
    Your functions could remove letters after periods and put the sentence into one string.
    Your function can allow the input of specific grep commands. (Links to an external site.)

## R for Data Science - Chapter 19, 29

Functions allow you to automate common tasks in a more powerful and general way than copy-and-pasting. Writing a function has three big advantages over using copy-and-paste:

    You can give a function an evocative name that makes your code easier to understand.

    As requirements change, you only need to update code in one place, instead of many.

    You eliminate the chance of making incidental mistakes when you copy and paste (i.e. updating a variable name in one place, but not in another).

There are three key steps to creating a new function:

    You need to pick a name for the function. Here I’ve used rescale01 because this function rescales a vector to lie between 0 and 1.

    You list the inputs, or arguments, to the function inside function. Here we have just one argument. If we had more the call would look like function(x, y, z).

    You place the code you have developed in body of the function, a { block that immediately follows function(...).

-An if statement allows you to conditionally execute code. It looks like this
-Be careful when testing for equality. == is vectorised, which means that it’s easy to get more than one output. Either check the length is already 1, collapse with all() or any(), or use the non-vectorised identical(). identical() is very strict: it always returns either a single TRUE or a single FALSE, and doesn’t coerce types. This means that you need to be careful when comparing integers and double
-You can use || (or) and && (and) to combine multiple logical expressions. These operators are “short-circuiting”: as soon as || sees the first TRUE it returns TRUE without computing anything else. As soon as && sees the first FALSE it returns FALSE. You should never use | or & in an if statement: these are vectorised operations that apply to multiple values (that’s why you use them in filter()). If you do have a logical vector, you can use any() or all() to collapse it to a single value.
-One useful technique is the switch() function. It allows you to evaluate selected code based on position or name.
-f you just want to capture the values of the ..., use list(...)
-The value returned by the function is usually the last statement it evaluates, but you can choose to return early by using return()
-There are two basic types of pipeable functions: transformations and side-effects. With transformations, an object is passed to the function’s first argument and a modified object is returned. With side-effects, the passed object is not transformed. Instead, the function performs an action on the object, like drawing a plot or saving a file. Side-effects functions should “invisibly” return the first argument, so that while they’re not printed they can still be used in a pipeline. 
-In R, this is valid code because R uses rules called lexical scoping to find the value associated with a name. Since y is not defined inside the function, R will look in the environment where the function was defined
-Every name is looked up using the same set of rules. For f() that includes the behaviour of two things that you might not expect: { and +. This allows you to do devious things like

MARKDOWN FORMATS

There are a number of basic variations on that theme, generating different types of documents:

    pdf_document makes a PDF with LaTeX (an open source document layout system), which you’ll need to install. RStudio will prompt you if you don’t already have it.

    word_document for Microsoft Word documents (.docx).

    odt_document for OpenDocument Text documents (.odt).

    rtf_document for Rich Text Format (.rtf) documents.

    md_document for a Markdown document. This isn’t typically useful by itself, but you might use it if, for example, your corporate CMS or lab wiki uses markdown.

    github_document: this is a tailored version of md_document designed for sharing on GitHub

-For html_documents another option is to make the code chunks hidden by default, but visible with a click:

    output:
      html_document:
        code_folding: hide
        
-html_notebook gives you a local preview, and a file that you can share via email. github_document creates a minimal md file that you can check into git. You can easily see how the results of your analysis (not just the code) change over time, and GitHub will render it for you nicely online.

-R Markdown comes with three presentation formats built-in:

    ioslides_presentation - HTML presentation with ioslides

    slidy_presentation - HTML presentation with W3C Slidy

    beamer_presentation - PDF presentation with LaTeX Beamer.

-Dashboards are a useful way to communicate large amounts of information visually and quickly. Flexdashboard makes it particularly easy to create dashboards using R Markdown and a convention for how the headers affect the layout:

    Each level 1 header (#) begins a new page in the dashboard.
    Each level 2 header (##) begins a new column.
    Each level 3 header (###) begins a new row.

-HTML is an interactive format, and you can take advantage of that interactivity with htmlwidgets, R functions that produce interactive HTML visualisations

-There are many packages that provide htmlwidgets, including:

    dygraphs, http://rstudio.github.io/dygraphs/, for interactive time series visualisations.

    DT, http://rstudio.github.io/DT/, for interactive tables.

    threejs, https://github.com/bwlewis/rthreejs for interactive 3d plots.

    DiagrammeR, http://rich-iannone.github.io/DiagrammeR/ for diagrams (like flow charts and simple node-link diagrams).

- use shiny, a package that allows you to create interactivity using R code, not JavaScript.
-To call Shiny code from an R Markdown document, add runtime: shiny to the header

-With a little additional infrastructure you can use R Markdown to generate a complete website:

    Put your .Rmd files in a single directory. index.Rmd will become the home page.

    Add a YAML file named _site.yml provides the navigation for the site. For example
    
## Data Wrangling


```r
# With the randomletters.txt file, pull out every 1700 letter (e.g. 1, 1700, 3400, …) and find the quote that is hidden - the quote ends with a period
pull_every_nth_letter <- function(n, string) {
  if (str_length(string)>0) {
    sequence_to_pull <- c(seq(0,str_length(string), by = n))
    #replace first element with 1
    sequence_to_pull[1] <- 1
    #initialize result
    result <- c()
    for (i in 1:length(sequence_to_pull)) {
      char <- str_sub(string, sequence_to_pull[i], sequence_to_pull[i])
      # after reaching a dot we stop
      if (char == ".") {
        result[i] <- char
        break
      } 
      result[i] <- char
    }
    result <- str_c(result, collapse = "")
    # built phrase
    return(result)
  } else {
    return("")
  }
}



# With the randomletters_wnumbers.txt file, find all the numbers hidden and convert those numbers to letters using the letters order in the alphabet to decipher the message
find_numbers_and_convert <- function(string) {
  if (str_length(string) > 0) {
    onlynumbers <- str_match_all(string, "([1-9][0-9]|[0-9])")
    alphabet <- c(letters[1:26])
    convert <- c()
    for (i in 1:length(onlynumbers[[1]])) {
      convert[i] <- alphabet[as.numeric(onlynumbers[[1]][i])]
    }
    convert <- str_c(convert, collapse = "")
    return(convert)
  } else {
    return("")
  }
  
}



#With the randomletters.txt file, remove all the spaces and periods from the string then find the longest sequence of vowels
remove_spaces_and_periods <- function(string) {
  if (str_length(string) > 0) {
    strip <- str_replace_all(string, "([.]|[ ])", "")
    #check
    str_locate_all(strip, "([.]|[ ])")
    return(strip)
  } else {
    return("")
  }
}


#max length of vowels from a string
max_vowel_seq <- function(string) {
  if (str_length(string) > 0) {
    maxseq <- str_locate_all(string, "([a|e|i|o|u]+)")
    maxseq <- max(maxseq[[1]])
    return(maxseq)
  } else {
    return("")
  }
}

#test functions
result1 <- pull_every_nth_letter(1700, rand_letters)
result2 <- find_numbers_and_convert(rand_numbers_and_letters)
result3 <- remove_spaces_and_periods(rand_letters)
result4 <- max_vowel_seq(rand_letters)
```
