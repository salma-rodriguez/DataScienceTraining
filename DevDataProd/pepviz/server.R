library(quantmod)
library(quadprog)
library(PerformanceAnalytics)
library(zoo)
source("helpers.R")

shinyServer(function(input, output) {
  
    dataInput <- function(in.sym, adj.splits = input$adj.splits) {
          validate (
              need(input$dates[2] >  input$dates[1], 
                  "End date is earlier than start date, or start date is blank.")
          )
          
          validate (
              need(as.Date(input$dates[2]) <= Sys.Date(), 
                  "End date took a leap forward in time!")
          )
          
          validate (
              need(difftime(input$dates[2], input$dates[1], "days") > 14, 
                  "The date range is less the 14 days. Try a bigger range of days.")
          )
          
          data <- try(getSymbols(in.sym, src = "yahoo", 
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE  )     )
          
          validate(
              need(!is.null(data) && class(data) != "try-error",
                  "Either we failed to connect, or we have an unregistered ticker symbol.")
          ); adjsplits(data, in.sym, adj.splits)
    }
    
    stockPrice <- function(in.sym) {
          if (!input$adjust) 
              return(dataInput(in.sym))
          adjust(dataInput(in.sym    ))
    }
  
    dailyReturns <- function(in.sym) {
            ts <- stockPrice(in.sym)
            dailyReturn(ts[, 6]   )
    }
    
    monthlyReturns <- function(in.sym) {
            ts <- stockPrice(in.sym)
            monthlyReturn(ts[, 6] , type = "log")
    }
    
    retrieve_acf <- function() {
            acf(stockPrice(input$sym1)[, 6], main = "Autocorrelation of Adjusted Closing Price")
    }
    
        
    output$plot1 <- renderPlot({
            chartSeries(stockPrice(input$sym1),
                        theme = chartTheme("white"), 
                        type = "line", log.scale = input$log, TA = NULL)
    })
    
    output$plot2 <- renderPlot({
            if (!input$log && input$misc == "drets")
                  chartSeries(dailyReturns(input$sym1), theme = chartTheme("white"),
                          type = "line", log.scale = input$log, TA = NULL)
            else if (!input$log && input$misc == "mrets")
                  chartSeries(monthlyReturns(input$sym1), theme = chartTheme("white"),
                          type = "line", log.scale = input$log, TA = NULL)
    })
    
    output$plot2a <- renderPlot({
            graphics::plot(as.numeric(dailyReturns("SPY")), 
                           as.numeric(dailyReturns(input$sym1)), 
                           pch = 19,
                           col = "darkgreen", xlab = "SPY", ylab = input$sym1,
                           main = bquote(paste("Correlation of ", .(input$sym1), " with SPY")))
            fit <- lm(as.numeric(dailyReturns("SPY")) ~ as.numeric(dailyReturns(input$sym1)))
            graphics::abline(fit)
            graphics::legend("topleft", NULL, sprintf("Beta: %.2f", summary(fit)$coef[2]))
    })
    
    output$plot2b <- renderPlot({
            retrieve_acf()
    })
    
    output$plot3 <- renderPlot({
            return_matrix <- coredata(monthlyReturns(input$sym1))
      
            par(mfrow=c(1,2))
            hist(return_matrix,main="Monthly Return",
                                xlab=input$sym1, probability=T, col="slateblue1")
      
            boxplot(return_matrix,outchar=T, main="Boxplot", col="slateblue1")
    })
    
    output$plot4 <- renderPlot({
            return_matrix <- coredata(monthlyReturns(input$sym1))
            
            par(mfrow=c(1,2))
            plot(density(return_matrix, na.rm = T),type="l", 
                 main="Smoothed Density",
                 xlab="Monthly Return", ylab="density estimate", col="slateblue1")
            
            qqnorm(return_matrix, col="slateblue1")
            qqline(return_matrix)
    })
    
    output$plot5 <- renderPlot({
            t_bill_rate <- input$tbill
            
            monthly1 <- monthlyReturns(input$sym2)
            monthly2 <- monthlyReturns(input$sym3)
            
            monthly_all <- data.frame(matrix(monthly1), matrix(monthly2))
            colnames(monthly_all) <- c(input$sym2, input$sym3)
            
            mu_hat_annual <- apply(monthly_all,2,mean)*nrow(monthly_all)
            sigma2_annual <- apply(monthly_all,2,var )*nrow(monthly_all)
            
            sigma_annual <- sqrt(sigma2_annual)
            
            cov_mat_annual <- cov(monthly_all)*nrow(monthly_all)
            cov_hat_annual <- cov(monthly_all)[1,2]*nrow(monthly_all)
            
            # construct portfolio with two assets
            
            stock1weights <- seq(from=-1, to=2, by=0.1)
            stock2weights <- 1 - stock1weights
            
            mu_portfolio <-  stock1weights*mu_hat_annual[1] + stock2weights*mu_hat_annual[2]
            
            sigma2_portfolio <- stock1weights^2*sigma2_annual[1] + 
                                stock2weights^2*sigma2_annual[2] +
                              2*stock1weights*stock2weights*cov_hat_annual
            sigma_portfolio <- sqrt(sigma2_portfolio)
            
            # compute tangency portfolio
            tangency_portfolio <-  tangency.portfolio(mu_hat_annual, cov_mat_annual, t_bill_rate)
            
            # plot portfolio risk vs returns
            plot(sigma_portfolio,
                 mu_portfolio, 
                 type="b", 
                 pch=16, 
                 ylim=c(0, max(mu_portfolio)), 
                 xlim=c(0, max(sigma_portfolio)), 
                 xlab=expression(sigma[p]), 
                 ylab=expression(mu[p]),
                 col=c(rep("green", 18), rep("red", 13)))
            
            text(x=sigma_annual[1], y=mu_hat_annual[1], labels=input$sym2, pos=4)
            text(x=sigma_annual[2], y=mu_hat_annual[2], labels=input$sym3, pos=4)
            
            # tangency weights
            tangency_weights <- seq(from=0, to=2, by=0.1)
            
            # tangency parameters
            mu_portfolio_tangency_bill <- t_bill_rate + tangency_weights*(tangency_portfolio$er - t_bill_rate)
            sigma_portfolio_tangency_bill <- tangency_weights*tangency_portfolio$sd
            
            # Plot portfolio combinations of tangency portfolio and T-bills
            text(x=tangency_portfolio$sd, y=tangency_portfolio$er, labels="Tangency", pos=2)
            points(sigma_portfolio_tangency_bill, mu_portfolio_tangency_bill, col = "blue", type = "b", pch=16)
            
            tangency_weight <- input$twght
            t_bill_weight <- 1-tangency_weight
            
            # Define the portfolio parameters
            mu_portfolio_efficient <- t_bill_rate + tangency_weight * (tangency_portfolio$er - t_bill_rate)
            
            sd_portfolio_efficient <- tangency_weight * tangency_portfolio$sd
            
            text(x=sd_portfolio_efficient, y=mu_portfolio_efficient, 
                    labels=bquote(paste("Efficient Portfolio with ", 
                   .(100*tangency_weight), "% Tangency")), 
                 pos=4, cex=0.75)
            points(sd_portfolio_efficient, mu_portfolio_efficient, col = "orange", type = "b", pch =16, cex = 2)
    })
    
    getopt.symbols <- function() {
            symbols <- NULL
            
            if (input$syms > 0)
                symbols <- c(symbols, input$sym4)
            
            if (input$syms > 1)
                symbols <- c(symbols, input$sym5)
            
            if (input$syms > 2)
                symbols <- c(symbols, input$sym6)
            
            if (input$syms > 3)
                symbols <- c(symbols, input$sym7)
            
            if (input$syms > 4)
                symbols <- c(symbols, input$sym8)
            
            if (input$syms > 5)
                symbols <- c(symbols, input$sym9)
            
            return (symbols)
    }
    
    getopt.returns <- function(symbols) {
            monthly <- NULL; for (i in 1:length(symbols)) {
                mo <- monthlyReturns(symbols[i])
                monthly <- c(monthly, mo)
            }; monthly
    }
    
    output$ui <- renderUI({
            sidebarPanel(
                if (input$syms > 0)
                    textInput("sym4", "Symbol 1", "AAPL"),
                
                if (input$syms > 1)
                    textInput("sym5", "Symbol 2", "BA"),
                
                if (input$syms > 3)
                    textInput("sym6", "Symbol 4", "IBM"),
                
                if (input$syms > 2)
                    textInput("sym7", "Symbol 3", "KO"),
                
                if (input$syms > 4)
                    textInput("sym8", "Symbol 5", "LHCG"),
                
                if (input$syms > 5)
                    textInput("sym9", "Symbol 6", "SBUX")
            )
    })
    
    output$plot6 <- renderPlot({
            symbols <- getopt.symbols()
            monthly <- getopt.returns(symbols)
            
            retsmat <- matrix(monthly, nrow = length(monthly)/input$syms, ncol = input$syms)
            
            monthly_all <- data.frame(retsmat)
            
            colnames(monthly_all) <- symbols
            
            mu_hat_annual <- apply(monthly_all,2,mean)*nrow(monthly_all)
            cov_mat_annual <- cov(monthly_all)*nrow(monthly_all)
            
            global_min_var_portfolio = globalMin.portfolio(mu_hat_annual, cov_mat_annual)
            
            plot.portfolio(global_min_var_portfolio)
    })
    
    output$plot7 <- renderPlot({
            symbols <- getopt.symbols()
            monthly <- getopt.returns(symbols)
            
            retsmat <- matrix(monthly, nrow = length(monthly)/input$syms, ncol = input$syms)
            
            monthly_all <- data.frame(retsmat)
            
            colnames(monthly_all) <- symbols
            
            mu_hat_monthly <- apply(monthly_all,2,mean)*nrow(monthly_all)
            cov_mat_monthly <- cov(monthly_all)*nrow(monthly_all)
            
            # The efficient frontier of risky assets 
            efficient_frontier <- efficient.frontier(mu_hat_monthly, 
                                                     cov_mat_monthly, 
                                                     alpha.min = -1, alpha.max = 1,
                                                     shorts = input$short1s)
            
            plot.Markowitz(efficient_frontier, input$plot.assets, input$plot.lines, mu_hat_monthly, cov_mat_monthly)
    })
    
    output$plot8 <- renderPlot({
            symbols <- getopt.symbols()
            monthly <- getopt.returns(symbols)
            
            retsmat <- matrix(monthly, nrow = length(monthly)/input$syms, ncol = input$syms)
            
            monthly_all <- data.frame(retsmat)
            
            colnames(monthly_all) <- symbols
      
            mu_hat_monthly <- apply(monthly_all,2,mean)*nrow(monthly_all)
            cov_mat_monthly <- cov(monthly_all)*nrow(monthly_all)
            
            # highest average return
            mu_target <- max(input$muhat)
            
            # short sales allowed
            efficient_porfolio_short <- efficient.portfolio(mu_hat_monthly, 
                                                            cov_mat_monthly, 
                                                            mu_target, 
                                                            shorts = input$shorts)
      
            plot.portfolio(efficient_porfolio_short)
    })

})