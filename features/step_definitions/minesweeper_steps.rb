Given /^the field$/ do |field_string|
  lines = field_string.split("\n").map &:split
  mines = []
  lines.each_with_index do |row, rindex|
    row.each_with_index { |col, cindex| mines << [rindex, cindex] if col == '*' }
  end
  Minesweeper.game.build rows: lines.length, cols: lines.map(&:length).max, mines: mines, mineCount: mines.length
end

When /^I click on the cell in the (\d+).. row and (\d+).. column$/ do |row, col|
  Minesweeper.game.click row.to_i-1, col.to_i-1
end

Then /^I should win$/ do
  Minesweeper.game.should be_won
end

Then /^I should lose$/ do
  Minesweeper.game.should be_lost
end

Then /^I should see the game$/ do |field_string|
  Minesweeper.game.status_grid.should == string_to_status_grid(field_string)
end

Then /^I can win the game without guessing$/ do
  robot = Minesweeper::Robot.new Minesweeper.game
  robot.play_game
  Minesweeper.game.should be_won
  robot.guesses.should == 0
  puts "Time taken: #{Minesweeper.game.time_taken}"
end

Then /^I should finish the game in (.+) seconds or less$/ do |expected_time|
  Minesweeper.game.time_taken.should be <= expected_time.to_i
end