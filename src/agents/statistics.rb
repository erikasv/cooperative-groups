class Statistics

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
# 		p "#{sumXY} - #{sumX} - #{sumY} - #{sumX2}"
		output=n*sumX2 - sumX**2
		if output != 0
			output= (n*sumXY - sumX*sumY) / output
		end
		
		return output
	end
	
	#Recibe dos arreglos de números
	#Retorna el coeficiente de regresión de la relación entre ellos
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
	
	#Recibe dos arreglos de números
	#Retorna la covarianza de ellos
	def self.covariance xValues, yValues
		#Covar=E(x.y)-E(x).E(y)
		product=Array.new
		xValues.each_index{
			|i|
			product << xValues[i]*yValues[i]
		}
		averageProduct=expectedValue product
		averageX=expectedValue xValues
		averageY=expectedValue yValues
		return averageProduct - (averageX*averageY)
	end
	
	#Recibe un arreglo de números
	#Retorna la varianza de ellos
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
	
	#Recibe un arreglo de números
	#Retorna la deviación estándar entre ellos
	def self.standarDeviation values
		var=variance values
		return Math.sqrt var
	end
	
	#Recibe un arreglo de números
	#Retorna el promedio de ellos
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
