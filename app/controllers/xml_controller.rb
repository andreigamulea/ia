class XmlController < ApplicationController
    def animaplant
      xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'animaplant.xlsx'))
  
      @header_row = []  # Inițializează array-ul pentru primul rând
      @second_row = []  # Inițializează array-ul pentru al doilea rând
  
      row_counter = 0
  
      xlsx.each_row_streaming(offset: 0, pad_cells: true) do |row|
        if row_counter == 0
          @header_row = row.map { |cell| cell&.value ? cell.value.to_s.strip : nil } # Salvează primul rând
        elsif row_counter == 23
          @second_row = row.map { |cell| cell&.value ? cell.value.to_s.strip : nil } # Salvează al doilea rând
          break # Ieșim după ce am citit al doilea rând
        end
        row_counter += 1
      end    
  
      # Ajustăm dimensiunea celui de-al doilea array astfel încât să fie identică cu header_row
      @second_row.fill(nil, @second_row.length...@header_row.length)
  
     
    end
  end
  