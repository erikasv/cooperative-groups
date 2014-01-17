# Author: Erika Suárez Valencia

# ==Description
# Used to calculate some statistics values
class Statistics

	# Calculates the regression coeficient by the least squares method
	# xValues:: independent variable
	# yValues:: dependent variable
	def self.regressionCoeficientLeastSquares xValues, yValues
		#Reg=n Sum(xy)-Sum(x)Sum(y) / n Sum(x^2) - Sum(x)^2
		n=xValues.size
		sumXY=0
		sumX=0
		sumY=0
		sumX2=0
		
		xValues.each_index{
			|i|
			sumXY+=xValues[i]*yValues[i]
			sumX+=xValues[i]
			sumY+=yValues[i]
			sumX2+=xValues[i]**2
		}
		output=n*sumX2 - sumX**2
		if output != 0
			output= (n*sumXY - sumX*sumY) / output
		end
		
		return output
	end
	
	# Calculates the regression coeficient
	# xValues:: independent variable
	# yValues:: dependent variable
	def self.regressionCoeficient xValues, yValues
		#Reg=Covar(x, y) / Var(x)
		covarianceXY=covariance xValues, yValues
		varianceX=variance xValues
		
		if varianceX == 0
			output=0
		else
			output=covarianceXY/varianceX
		end
		return output
	end
	
	# Calculates the covariance between the variables
	# xValues:: independent variable
	# yValues:: dependent variable
	def self.covariance xValues, yValues
		#Covar=E[(x-E[x])-(y-E[y])]
		averageX= expectedValue xValues
		averageY= expectedValue yValues
		finalValues=Array.new
		
		xValues.each_index{
			|i|
			finalValues<< (xValues[i]-averageX)*(yValues[i]-averageY)
		}
		
		result=expectedValue finalValues
		
		return result
	end
	
	# Calculates the variance of the numbers
	# xValues:: array with the values
	def self.variance values
		#Var(x)=Sum(xi^2)-E(x)^2
		average=expectedValue values
		squaredDifferences=Array.new
		values.each{
			|value|
			squaredDifferences<<(value-average)**2
		}
		averageSquaredDifferences=expectedValue squaredDifferences
		return averageSquaredDifferences
	end
	
	# Calculates the standard deviation of the numbers
	# xValues:: array with the values
	def self.standardDeviation values
		var=variance values
		return Math.sqrt var
	end
	
	# Calculates the average of the numbers
	# xValues:: array with the values
	def self.expectedValue values
		#E(x)=Sum(xi)/n
		total=0
		values.each{
			|value|
			total += value
		}
		return total/values.size
	end
end
