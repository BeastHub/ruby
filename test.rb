require 'ruby2d'
GRID_SIZE = 20
SIZE = 25
WIDTH = 1240
HEIGHT = 720
GRID_WIDTH = WIDTH/GRID_SIZE
GRID_HEIGHT = HEIGHT/GRID_SIZE


class Letter
    attr_writer :character
    attr_writer :x
    attr_writer :y
    attr_writer :textLetter
    attr_writer :endTime
    attr_writer :durationTime
    attr_writer :textDuration
    attr_writer :fallingSpeed

    def initialize()
        @startTime = Time.now
        @durationTime = 0
        @letters = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','w','q','z','x','v']
        @character = @letters[rand(@letters.length)]
        @x = rand(1..WIDTH-SIZE)
        @y = rand(1..HEIGHT/2)
        @fallingSpeed = 4
    end
    def startTime
        @startTime
    end
    def endTime
        @endTime
    end
    def durationTime
        if(endTime!=nil)
            @durationTime = @endTime - @startTime
        else
            @durationTime = 0
        end
    end
    def textDuration
        @textDuration
    end
    def character
        @character
    end
    def x
        @x
    end
    def y
        @y
    end
    def fallingSpeed
        @fallingSpeed
    end
    def textLetter
        @textLetter
    end
    def draw
        @textLetter = Text.new(@character, color: "black", x: @x, y: @y , size: SIZE*2)
        @endTime = Time.now
        @durationTime = @endTime - @startTime
        @textDuration = Text.new(@durationTime, color: "green", x: 10, y: 10, size: SIZE)
    end
end

set background: 'gray'
set fps_cap: 60
set width: WIDTH
set height: HEIGHT
letter = Letter.new
scores = Array.new
gameover = false
keys = 0
start = false
on :key_down do |event|
    if(letter.character).include?(event.key)
        keys += 1
        scores.push(letter.durationTime)
        letter = Letter.new
    elsif(event.key == "r" && gameover)
        keys = 0;
        scores.clear
        gameover = false
        letter = Letter.new
    elsif(event.key == "return" && !gameover)
        gameover = true
        gameOver(scores)
    elsif(event.key == "return" && !start)
        gameover = false
        start = true
    elsif(event.key == "escape")
        exit(true)
    else
        letter.fallingSpeed += 0.5
    end
end
def gameOver(scores)
    start = false
    clear
    avgTime = (scores.reduce(:+).to_f / scores.size).round(2).to_s
    Text.new("Press r to reset", color: "black", x: 10 , y: 10, size: SIZE)
    if(avgTime == "NaN")
        avgTime=0
    end
    Text.new("Your average time: "+avgTime.to_s + " in " + scores.size.to_s + " keys :)", color: "black", x: (WIDTH/2) - 400, y: (HEIGHT/2), size: SIZE*2)

end
def menu
    clear
    Text.new("Press enter to start and to finish", color: "black", x: (WIDTH/2) - 200 , y: (HEIGHT/2) - 50, size: SIZE)
end
update do
    menu
    if(start)
        if(!gameover)
            clear
            keysText = Text.new(keys, color: "black", x: WIDTH/2, y: 10, size: SIZE*3)
            letter.y += letter.fallingSpeed
            letter.draw
            if(letter.textLetter.y >= HEIGHT)
                gameover = true
            end
        else
            gameOver(scores)
        end
    end
end

show