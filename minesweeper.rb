require 'watir-webdriver'
require 'bench'
require 'nokogiri'

class Field
  def table_to_field table
    field = []
    table.rows.each do |row|
      a_row = []
      row.cells.each do |cell|
        a_row << cell.class_name
      end
      field << a_row
    end
    field
  end

  def iterate_over_table_to_field b, number_rows, number_cols
    field = []
    number_rows.times do |row|
      a_row = []
      number_cols.times do |col|
        a_row << b.td(:id => "r#{row}c#{col}").class_name
      end
      field << a_row
    end
  end

  def table_html_to_field html
    field = []
    doc = Nokogiri::HTML html
    doc.css('tr').each do |row|
      a_row = []
      row.css('td').each do |col|
        a_row << col[:class]
      end
      field << a_row
    end
    field
  end


end

field = Field.new
Watir::always_locate = false
b = Watir::Browser.start 'file:///Users/alscott/Projects/minesweeper/index.html'
number_rows = b.div(:id => 'minesweeper').table.rows.count
number_cols = b.div(:id => 'minesweeper').table.row.cells.count

benchmark 'extract' do
   field.table_to_field b.div(:id => 'minesweeper').table
end

benchmark 'iterate' do
  field.iterate_over_table_to_field b, number_rows, number_cols
end

benchmark 'nokogiri' do
  field.table_html_to_field b.div(:id => 'minesweeper').table.html
end

run 1