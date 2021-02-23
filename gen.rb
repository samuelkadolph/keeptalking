#!/usr/bin/env ruby

URL = "https://www.bombmanual.com/print/KeepTalkingAndNobodyExplodes-BombDefusalManual-v1.pdf"
SIG = "2bcc12b957a8ff2334a56addff0e8138ab9b6b006bd513ca06facd44a090cdd4"

require "bundler/inline"
require "digest/sha2"
require "net/http"

gemfile do
  source "https://rubygems.org"

  gem "combine_pdf", "~> 1.0"
  gem "prawn", "~> 2.4"
end

root = File.expand_path(File.dirname(__FILE__))
tmp = File.join(root, "tmp")

manual = File.join(tmp, "manual.pdf")
overlay = File.join(tmp, "overlay.pdf")
combined = File.join(tmp, "combined.pdf")

if !File.exists?(manual)
  res = Net::HTTP.get_response(URI(URL))
  res.error! unless res.code == "200"

  raise "Signature does not match" if Digest::SHA256.hexdigest(res.body) != SIG

  File.open(manual, "w") do |f|
    f.write(res.body)
  end
end

Prawn::Document.generate(overlay) do
  font File.join(root, "assets", "DejaVuSansMono.ttf")
  font_size 14

  # Pages 1 - 12
  12.times { start_new_page }

  # Page 13
  transparent(0.25) do
    middle = [248, 422]
    rotate -45, origin: middle do
      fill_color "FF0000"
      fill_ellipse middle, 131, 69.5
    end

    middle = [292, 422]
    rotate 45, origin: middle do
      fill_color "0000FF"
      fill_ellipse middle, 131, 69.5
    end
  end

  start_new_page

  # Page 14
  start_new_page

  # Page 15
  cols = [ 56.25,  80.25, 104.25, 128.25, 152.25, 176.25,
          210.00, 234.00, 258.00, 282.00, 306.00, 330.00,
          363.75, 387.75, 411.75, 435.75, 459.75, 483.75]
  rows = [513.75, 489.75, 465.75, 441.75, 417.75, 393.75,
          360.00, 336.00, 312.00, 288.00, 264.00, 240.00,
          206.25, 182.25, 158.25, 134.25, 110.25,  86.25]

  text_t = 535
  text_b = 65
  text_l = 35
  text_r = 505

  size = 14
  margin = size / 2

  # rows.each { |r| stroke_horizontal_line text_l, text_r, at: r }
  # cols.each { |c| stroke_vertical_line   text_t, text_b, at: c }

  cols.zip(("1".."6").to_a * 3).each do |x, t|
    text_box t, align: :center, at: [x - margin, text_t + margin], height: size, overflow: :truncate, valign: :center, width: size
    text_box t, align: :center, at: [x - margin, text_b + margin], height: size, overflow: :truncate, valign: :center, width: size
  end

  rows.zip(("A".."F").to_a * 3).each do |y, t|
    text_box t, align: :center, at: [text_l - margin, y + margin], height: size, overflow: :truncate, valign: :center, width: size
    text_box t, align: :center, at: [text_r - margin, y + margin], height: size, overflow: :truncate, valign: :center, width: size
  end

  start_new_page

  # Pages 16 - 19
  4.times { start_new_page }

  # Page 20
  transparent(0.25) do
    fill_color "FF8000"

    # Up
    fill_rectangle [169.50, 454.50], 33, 21.75
    fill_rectangle [203.25, 454.50], 33, 21.75
    fill_rectangle [203.25, 432.00], 33, 21.75

    fill_rectangle [403.50, 454.50], 33, 21.75
    fill_rectangle [403.50, 432.00], 33, 21.75
    fill_rectangle [437.25, 432.00], 33, 21.75

    # Down
    fill_rectangle [ 68.25, 376.50], 33, 21.75
    fill_rectangle [ 68.25, 354.00], 33, 21.75

    fill_rectangle [268.50, 376.50], 33, 21.75
    fill_rectangle [302.25, 354.00], 33, 21.75
    fill_rectangle [336.00, 376.50], 33, 21.75
    fill_rectangle [369.75, 354.00], 33, 21.75
    fill_rectangle [403.50, 376.50], 33, 21.75
    fill_rectangle [437.25, 354.00], 33, 21.75

    # Left
    fill_rectangle [ 68.25, 297.75], 33, 21.75
    fill_rectangle [ 68.25, 275.25], 33, 21.75
    fill_rectangle [302.25, 297.75], 33, 21.75
    fill_rectangle [302.25, 275.25], 33, 21.75

    # Right
    fill_rectangle [ 34.50, 219.75], 33, 21.75
    fill_rectangle [ 34.50, 197.25], 33, 21.75
    fill_rectangle [268.50, 219.75], 33, 21.75
    fill_rectangle [268.50, 197.25], 33, 21.75
  end

  start_new_page

  # Pages 21-23
  2.times { start_new_page }
end

overlay_pdf = CombinePDF.load(overlay)
manual_pdf = CombinePDF.load(manual)

manual_pdf.pages.zip(overlay_pdf.pages).each do |manual_page, overlay_page|
  manual_page << overlay_page
end

# Insert blank page for better duplex printing
manual_pdf.insert(1, CombinePDF.create_page)

manual_pdf.save(combined)

