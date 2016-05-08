library(shiny)

shinyUI(navbarPage(
  titlePanel("PEPViz"),
  tabPanel("About",
           mainPanel(h1("Preparing Efficient Portfolios (with Visualization)"),
                     hr(),
                 h3("Introduction"),
                     p("This is a financial application to visualize stock information and allocate equities in 
                        a portfolio of stocks. Currently, up to six equities are supported for optimization.
                        We implement the efficient market hypothesis (EMH) when performing portfolio analysis.
                        Following the Markowitz portfolio theory, we assume that the risk of a portfolio can be
                        completely explained by its variance."),
                 h3("How to Navigate"),
                     p("This application allows the end user to perform several analyses of assets under
                        management (AUM). The supported features are described below."),
                     h4("Basic"),
                         p("If the end user selects the \'Basic\' tab above, he or she is brought to the \'Basic\' 
                           window, where the end user can make a basic time series plot of data pulled from
                           Yahoo! Finance. The user may also plot the prices on a log scale or adjust for inflation
                           using data from the Federal Reserve Bank of St. Louis."),
                         img(src = "image1.png", width = "1200em"),
                     h4("Advanced"),
                         p("Various advanced plots can be drawn for the equity symbol selected on the \'Basic\' tab.
                            These plots are as follows."),
                         strong("Time Series Plot: "), p("This is a time series plot of the daily or monthly return.
                                 Monthly return is on a log scale for computational convenience. Therefore, we have 
                                 a continuously compounded return being plotted and not the simple return. Note that
                                 the geometric (continuous) return is an accurate approximation to the arithmetic
                                 (simple) return under the assumptions of the constant expected return (CER) model.
                                 If the expected return is not constant, then continuously compounded returns may be 
                                 unusable."),
                         img(src = "image2.png", width = "400em"), br(),
                         strong("Monthly Return: "), p("This is a density barplot of the monthly return of the
                                 given equity, which is good for showing the spread of the probability mass about 
                                 the expected value of equity returns. Use this plot to analyze the distribution.
                                 Below is a stock with ticker symbol GHC, exhibiting a distribution that is close to
                                 Gaussian normal, between Jan 01, 2013 and Feb 09, 2016."),
                         img(src = "image3.png", width = "500em"), br(),
                         strong("Boxplot: "), p("This plot illustrates the interquartile range about the median equity
                                 price, It captures critical values and outliers. Use this plot to
                                 analyze returns that fall beyond the critical value. Having many outliers is usually 
                                 caused by extreme price fluctuations, such as during a crisis period in a particular
                                 business cycle."),
                         img(src = "image4.png", width = "500em"), br(),
                         strong("Smoothed Density: "), p("Generate a smoothed density plot, similar to the monthly
                                 return plot above but having a smoother texture."),
                         strong("Normal Q-Q Plot: "), p("Create a quantile-quantile plot to appreciate the differences 
                                 between the theoretical quantiles of equity returns and observed sample quantiles."),
                         br(),
                         img(src = "image5a.png", width = "550em"), img(src = "image5b.png", width = "550em"), br(),
                         br(), p(strong("Top Left: "), "Equity with positive return skewness | ", strong("Top Right: "),
                                "Equity with negative return skewness"),
                         strong("Correlation: "), p("Plot the beta coefficient of an equity, compared to the S&P 500
                                 tracking SPY exchange-traded fund (ETF)."), br(),
                         img(src = "image6.png", width = "900em"), br(),
                         strong("Autocorrelation: "), p("Generate a plot of the autocorrelation function of the equity
                                 specified in the \'Basic\' tab. Note that the autocorrelation function works best with
                                 small time frames, e.g., 14-31 trading days. Generally, it 
                                 is not recommended to use this plot for analysis of equity securities, but ideas can
                                 be explored by the end user, such as tracking volatility in options contracts.
                                 Below we have a plot of the autocorrelation function for the Coca-Cola Company (KO) 
                                 from Jan 04, 2016 to Feb 09, 2016."),
                         img(src = "image7.png", width = "900em"), br(),
                         p("The dotted blue lines on the plot above are said to form a ", strong("confidence band."),
                           " There is low volatility within the confidence band."),
                     hr(),
                 h3("Acknowledgements"),
                     p("We would like to thank Professor Eric Zivot and his students from the University of Washington 
                        for his course on computational finance, from which we got some of the code for completing the 
                        PEP Viz application."),
                 h3("About the Author"),
                     p("This application was written by Mr. Salma Y Rodriguez, a software engineer at IBM 
                        and enthusiast of quantitative research, who knows very little about finance.
                        The author wrote this program with the intention of doing his own asset management,
                        since he is very concerned about his personal finances.")
            )
  ),
  
  tabPanel("Basic",
           
           sidebarLayout(
             
             sidebarPanel(
                   helpText("Select a stock to examine. 
                            Information will be collected from yahoo finance."),
                   
                   textInput("sym1", "Symbol", "COST"),
                   
                   dateRangeInput("dates","Date Range",
                                  start = "2013-01-01",
                                  end = as.character(Sys.Date())),
                   
                   actionButton("get", "Get Stock"),
                   
                   br(),br(),
                   
                   checkboxInput("log", "Plot y axis on log scale.", 
                                 value = FALSE),
                   
                   checkboxInput("adjust", 
                                 "Adjust prices for inflation.", value = FALSE),
                   
                   checkboxInput("adj.splits",
                                 "Adjust prices for splits and dividends.")
              ),
             
             mainPanel(plotOutput("plot1")))
  ),
  
  tabPanel("Advanced",
           helpText("Generate advanced plots for assets on \"Basic\" tab, 
                    such as daily returns and QQ plot."),
           sidebarPanel(
                    radioButtons("misc", "Time Series Plot",
                          c("Daily Return" = "drets",
                            "Monthly Return" = "mrets"))),
           
           mainPanel(plotOutput("plot2"),
                     plotOutput("plot3"),
                     plotOutput("plot4"),
                     plotOutput("plot2a"),
                     plotOutput("plot2b"))
  ),
  
  tabPanel("Tangency Portfolio",
           helpText("Compute the tangency portfolio for two different assets
                    with given T-bill rate."),
           sidebarPanel(
             sliderInput("tbill", "T-bill Rate", 
                         min = 0.00,
                         max = 0.09,
                         step = 0.01,
                         value = 0.03,
                         format = "#.##"),
             sliderInput("twght", "Tangency Weight", 
                         min = 0.0,
                         max = 1.0,
                         step = 0.1,
                         value = 0.3,
                         format = "#.##"),
             textInput("sym2", "Symbol 1", "AAPL"),
             textInput("sym3", "Symbol 2", "COST")),
           
           mainPanel(plotOutput("plot5"))
  ),
  
  tabPanel("Portfolio Optimization",
           sidebarPanel(
                helpText("Choose number of equities in the portfolio."),
                sliderInput("syms", "No. of Symbols", 
                                      min = 1, max = 6, value = 6)
           ),
           sidebarPanel(
                helpText("Specify the portfolio equities on the right.")
           ),
           uiOutput("ui")
  ),
  
  tabPanel("GMinVar Portfolio",
           sidebarPanel(
                helpText("Compute the global minimum variance portfolio.")
           ),
           mainPanel(plotOutput("plot6"))
  ),
  
  tabPanel("Efficient Frontier",
           helpText("Compute the efficient frontier of the given assets."),
           checkboxInput("short1s",
                         "Allow short sales.",
                         value = FALSE),
           checkboxInput("plot.assets",
                         "Include assets in plot.",
                         value = FALSE),
           checkboxInput("plot.lines",
                         "Add quantiles to graph.",
                         value = FALSE),
           mainPanel(plotOutput("plot7"))),
  
  tabPanel("Efficient Portfolio",
           helpText("Compute an efficient portfolio with a given target return."),
           checkboxInput("shorts",
                         "Allow short sales.",
                         value = FALSE),
           sidebarPanel(
                sliderInput("muhat", "Target Return", 
                         min = 0.01,
                         max = 0.90,
                         step = 0.01,
                         value = 0.40,
                         format = "#.##")
           ),
           
           mainPanel(plotOutput("plot8"))
  )
  
))