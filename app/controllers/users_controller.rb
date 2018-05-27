class UsersController < ApplicationController 
    before_action :authenticate_user!
    
    def index
        @users = User.all.order("return DESC")
        
        @users.each do |user|
            
            stock_one = StockQuote::Stock.quote(user.stock1)
            stock_two = StockQuote::Stock.quote(user.stock2)

            if stock_one == nil || stock_two == nil
                user.return = nil
                user.save
            else
                s1 = StockQuote::Stock.chart(user.stock1).chart 
                s2 = StockQuote::Stock.chart(user.stock2).chart

                day = Time.now.wday
                hour = Time.now.hour

                if (day == 1)
                    r1 = 0
                    r2 = 0
                elsif (day == 2)
                    r1 = ((s1[s1.length - 1]["close"] - s1[s1.length - 1]["open"])/(s1[s1.length - 1]["open"]).abs)*100
                    r2 = ((s2[s2.length - 1]["close"] - s2[s2.length - 1]["open"])/(s2[s2.length - 1]["open"]).abs)*100
                elsif (day == 3)
                    r1 = ((s1[s1.length - 1]["close"] - s1[s1.length - 2]["open"])/(s1[s1.length - 2]["open"]).abs)*100
                    r2 = ((s2[s2.length - 1]["close"] - s2[s2.length - 2]["open"])/(s2[s2.length - 2]["open"]).abs)*100
                elsif (day == 4)
                    r1 = ((s1[s1.length - 1]["close"] - s1[s1.length - 3]["open"])/(s1[s1.length - 3]["open"]).abs)*100
                    r2 = ((s2[s2.length - 1]["close"] - s2[s2.length - 3]["open"])/(s2[s2.length - 3]["open"]).abs)*100
                elsif (day == 5)
                    r1 = ((s1[s1.length - 1]["close"] - s1[s1.length - 4]["open"])/(s1[s1.length - 4]["open"]).abs)*100
                    r2 = ((s2[s2.length - 1]["close"] - s2[s2.length - 4]["open"])/(s2[s2.length - 4]["open"]).abs)*100
                else
                    r1 = ((s1[s1.length - 1]["close"] - s1[s1.length - 5]["open"])/(s1[s1.length - 5]["open"]).abs)*100
                    r2 = ((s2[s2.length - 1]["close"] - s2[s2.length - 5]["open"])/(s2[s2.length - 5]["open"]).abs)*100
                end

                    user.return = (r1 + r2)/2
                    user.save

            end 
            
        end
    end
    
    def edit
      @user = current_user
    end

   def update
       
      if current_user.update_attributes(user_params)
        
        if current_user.stock1 == "" || current_user.stock1 == "808"
            stock_one = nil
        else
            stock_one = StockQuote::Stock.quote(current_user.stock1)
            price_one = StockQuote::Stock.quote(current_user.stock1).latest_price
        end
          
        if current_user.stock2 == "" || current_user.stock2 == "808"
            stock_two = nil
        else
            stock_two = StockQuote::Stock.quote(current_user.stock2)
            price_two = StockQuote::Stock.quote(current_user.stock2).latest_price
        end

        if stock_one == nil || price_one < 5
            flash[:notice] = "The first stock you picked is not supported by this platform"
            current_user.stock1 = "808"
            current_user.save
            
            render :edit
        elsif stock_two == nil || price_two < 5
            flash[:notice] = "The second stock you picked is not supported by this platform"
            current_user.stock2 = "808"
            current_user.save
            
            render :edit
        else
            flash[:notice] = "Successfully updated"
            render :edit  
        end
          
      else
        render :edit
      end
       
   end
    
    
    private
    
        def user_params
            params.require(:user).permit(:stock1, :stock2)
        end
    
end
