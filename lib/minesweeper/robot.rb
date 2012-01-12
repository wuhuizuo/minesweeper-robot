require 'minesweeper/field_analyser'

class Minesweeper::Robot
  def initialize game
    @game = game
  end

  def obvious_mines
    obvious_mines = []
    @game.field.each_with_index do |row, row_num|
      row.each_with_index do |cell, col_num|
        obvious_mines << [row_num, col_num] if cell == 'mines2' and neighbours(row_num, col_num) == 2
      end
    end
    obvious_mines
    [[1,1]]
  end

  def play options={}
    beginner =     {rows: 9,  cols: 9,  mineCount: 10}
    intermediate = {rows: 16, cols: 16, mineCount: 40}
    expert =       {rows: 16, cols: 30, mineCount: 99}
    @options = expert.merge options
    rows,cols,mineCount = *%w{rows cols mineCount}.map {|key| @options[key.to_sym] }
    won = 0
    lost = 0
    while true
      @game.reset @options
      make_move rows, cols, mineCount
      won += 1 if @game.won?
      lost += 1 if @game.lost?
      puts "won: #{won}, lost: #{lost}"
    end
  end

  def make_move rows, cols, mines
    turn = 0
    while true
      return if @game.won? or @game.lost?
      puts "Turn #{turn}"
      field.obvious_mines.tap {|it| puts "Marking obvious mines #{it.inspect}"}.each do |mine|
        @game.right_click *mine
      end
      @game.click *next_cell
      turn += 1
    end
  end

  def next_cell
    safe_cells = field.safe_cells_to_click
    unless safe_cells.empty?
      puts "Clicking safe cell #{safe_cells.first.inspect}"
      return safe_cells.first
    end
    field.least_likely_to_be_mined.tap {|it| puts "Guessing next cell #{it.inspect}"}
  end

  private

  def field
    Minesweeper::FieldAnalyser.new @game.field, @options[:mineCount]
  end
end