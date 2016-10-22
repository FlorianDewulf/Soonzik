#
# This module is to manage audio files like cutting or get the duration of it
#
module	Multimedia
	#
	# The class to cut a file for preview
	#
	class	CutAudio

		ERROR = ' 2>&1'
  	MAIN_REGEX = /Duration: (\d\d:\d\d:\d\d)/

		# The constructor. Take one parameter, the file to cut. It's optionnal and can be set later
		def initialize(dir = nil, file = nil)
			@os = nil
			@bits = 32
			@directory = dir
			@file = file
			@file_type = nil
			@begin = nil
			@end = nil
			@extension = ""

			if dir == nil
		    raise TypeError, 'dir is missing'
			end

			if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    		@os = "win"
    		@bits = 64 if ENV.has_key?('ProgramFiles(x86)')
    		@extension = ".exe"
    	else
    		if (/darwin/ =~ RUBY_PLATFORM) != nil
    			@os = "mac"
    		else
	    		@os = "linux"
	    	end

	    	@bits = 64 if 1.size == 8
	    end

	    @file_type = File.extname("#{@directory}/#{file}") if @file != nil
		end

		# To get the duration of the file
		def determine_duration
			if @file != nil
				return getDuration(@file)
			else
				return nil
			end
		end

		# To set the second to start the cut
		def determineStart(i = 0)
			@begin = i
		end

		# To set the second to end the cut
		def determineEnd(i = 0)
			@end = i
		end

		# To know if the start is set
		def isStart?
			return @begin != nil
		end

		# To know if the end is set
		def isEnd?
			return @end != nil
		end

		# To set or change the file to use
		def setFile(file = nil)
			@file = file
	    @file_type = File.extname("#{@directory}/#{@file}") if @file != nil
		end

		# Function to cut the file with the limit set before
		def cut
			if (!isStart? || !isEnd? || @file == nil)
				return nil
			end

			file = @file
			directory = @directory
			output_file = "cut_" + @file
	  	if file.include?(' ') || file.include?("'") || directory.include?(' ') || directory.include?("'")
	      file = file.to_s.dup
	      output_file = output_file.to_s.dup
	      directory = directory.to_s.dup
	      file = file+'"'
	      output_file = +output_file+'"'
	      directory = '"' + directory
	    end

	  	to_exec = "#{getFFMPEGexec()} -i #{directory}/#{file} -ss #{@begin} -t #{@end - @begin} #{directory}/#{output_file}" + ERROR
	  	output = `#{to_exec}`
	  	return output
		end

		# PRIVATE FUNCTIONS
		private
			# To calculate the duration
			def getDuration(file)
		    case @file_type.delete('.') # case tag
			    when 'mp4','m4a','m4v', 'wav', 'avi', 'flv', 'mp3'
			      @file_duration = ffmpeg_to_parse
			    else # All other files are not registered, so we assume them to have a duration length of 0.
			      @file_duration = 0
		    end
		    raise TypeError, 'Can\'t get the duration' if @file_duration.nil?
		    return @file_duration
		  end

		  # To parse the ffmpeg output
		  def ffmpeg_to_parse
				file = @file
				directory = @directory
				output_file = "cut_" + @file
		  	if file.include?(' ') || file.include?("'") || directory.include?(' ') || directory.include?("'")
		      file = file.to_s.dup
		      directory = directory.to_s.dup
		      file = file+'"'
		      directory = '"' + directory
		    end

		  	to_exec = "#{getFFMPEGexec()} -i #{directory}/#{file}" + ERROR
		  	output = `#{to_exec}`

		  	if output.include? 'command not found' # Check here whether we have installed ffmpeg or not.
		      raise LoadError, 'Can\'t find ffmpeg'
		    else
		      _ = output.match(MAIN_REGEX)[1]
		      # Must convert the format given in _ to seconds.
		      duration = timeToSecond(_)
		      return duration
		    end
		  end

		  # To format the time into seconds
		  def timeToSecond(duration)
		  	splitted = duration.split(':')
		    seconds  = splitted[0].to_i * 60 * 60 # Add hours here.
		    seconds += splitted[1].to_i * 60      # Add minutes here.
		    seconds += splitted[2].to_i           # Add Seconds here.
		    return seconds
		  end

		  #
		  def getFFMPEGexec
		  	return Rails.root.join('app', 'assets', 'execs', "ffmpeg-#{@os}-#{@bits}bits#{@extension}").to_s
		  end
	end
end