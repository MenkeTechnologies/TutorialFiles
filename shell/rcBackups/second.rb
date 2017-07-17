#!/usr/bin/env ruby

# require "benchmark"

# def calculation_with_explicit_block_passing(a, b, operation)
#  operation.call(a, b)
# end

# def calculation_with_implicit_block_passing(a, b)
#  yield(a, b)
# end

# Benchmark.bmbm (100) do |report|

# 	report.report("explicit") do
# 		addition = lambda { |a,b| a+b }
# 		1000.times { calculation_with_explicit_block_passing(5,5,addition) }
# 	end
# 	report.report("implicit") do
# 		1000.times { calculation_with_implicit_block_passing(5,5){|a,b| a+b}}
# 	end
# 	end

# puts Benchmark.measure{ "A" * 100_000_000_0}

# class Calculator
# 	def add(a,b)
# 		a+b
# 	end

# 	def calculation(a,b)
# 		yield (a,b)
# 	end
# end

# p add.call(2,36,235,3,231,23,2)

# add_method = Calculator.new.method("add")

# p add_method.to_proc.call(6,11)

# p Calculator.new.calculation(5,2) { |a,b| a +b}

class Item
	attr_accessor :qty, :item_name

	def initialize(item_name, qty)
		@item_name = item_name
		@qty = qty
	end

	def inspect
		"result of inspect"
	end
end

require 'hola'

Hola.hi
