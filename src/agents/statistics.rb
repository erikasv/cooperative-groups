class Statistics

	#Recibe dos arreglos de números
	#Retorna el coeficiente de regresión de la relación entre ellos
	def self.regressionCoeficient xValues, yValues
		#Reg=Covar(x, y) / Var(x)
		covarianceXY=covariance xValues, yValues
		varianceX=variance xValues
		
		if covarianceXY == 0
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
		sumSquaredValues=0
		values.each{
			|value|
			sumSquaredValues+=value**2
		}
		return sumSquaredValues - (average**2)
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
