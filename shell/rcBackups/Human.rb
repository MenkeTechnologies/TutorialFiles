#!/usr/bin/env ruby
module Human
	attr_accessor :name, :height, :weight

	def run
		puts self.name + " runs"
	end
end
