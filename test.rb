# => Definition of Rover
class Rover

	attr_accessor :x, :y, :dir, :x_max, :y_max, :directions

	# => Constructor
	def initialize
		@directions = ["E", "S", "W", "N"]
		@x_max = 5
		@y_max = 5
		set_position(0, 0, "N")
	end

	def self.set_bound(x_max, y_max)
		@x_max = x_max
		@y_max = y_max
	end

	def set_position(x, y, dir)
		@x = x unless x > @x_max
		@y = y unless y > @y_max
		@dir = dir unless @directions.index(dir) == -1
	end

	def get_position
		[@x.to_s, @y.to_s, @dir].join(" ")
	end

	def left
		p @directions.index(@dir)
		@dir = @directions[(@directions.index(@dir) + 3) % 4]
	end

	def right
		@dir = @directions[(@directions.index(@dir) + 1) % 4]
	end

	def move
		if @directions.index(@dir) == 0
			@x += 1 if @x < @x_max
		elsif @directions.index(@dir) == 1
			@y -= 1 if @y > 0
		elsif @directions.index(@dir) == 2
			@x -= 1 if @x > 0
		else
			@y += 1 if @x < @y_max
		end
	end

end
# End of Rover

# => Definition of Robert
class Robert

	attr_accessor :rover, :instructions

	def initialize
		@rover = Rover.new
		@instructions = []
	end

	def land(position)
		p "Landed to " + position
		@rover.set_position(position.split(" ")[0].to_i, position.split(" ")[1].to_i, position.split(" ")[2])
	end

	def set_instruction(instruction)
		instruction.split("").each do |inst|
			instructions << inst
		end
	end

	def go(instruction)
		if instruction == "L" or instruction == "l"
			@rover.left
		elsif instruction == "R" or instruction == "r"
			@rover.right
		elsif instruction == "M" or instruction == "m"
			@rover.move
		end
		p "Instruction : " + instruction + " => Position : " + rover.get_position
	end

	def execute
		p "======================================================"
		p "The robert started to move from <" + rover.get_position + ">"
		instructions.each do |instruction|
			go(instruction)
		end
		p "Destination is : <" + rover.get_position + ">"
		p
	end

end
# End of Robert

# => Definition of Application
class Application

	attr_accessor :roberts

	def initialize
		@roberts = []
		lines = []
		index = 0
		File.open("instruction.txt", "r").each_line do |line|
			lines[index] = line[0,line.index("\n")||line.length]
			index += 1
		end

		Rover.set_bound(lines[0].split(" ")[0].to_i, lines[0].split(" ")[1].to_i)
		r1 = Robert.new
		lines[0]
		r1.land(lines[1])
		r1.set_instruction(lines[2])
		@roberts << r1

		r2 = Robert.new
		r2.land(lines[3])
		r2.set_instruction(lines[4])
		@roberts << r2
	end

	def start
		p "The application is launching"
		@roberts.each do |robert|
			robert.execute
		end
		p "Thank you!"
	end

	def restart
		initialize
		start
	end
end
# End of Application

app = Application.new
app.start