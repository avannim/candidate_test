# frozen_string_literal: true

When(/^захожу на страницу "(.+?)"$/) do |url|
  visit url
  $logger.info("Страница #{url} открыта")
  sleep 1
end

When(/^ввожу в поисковой строке текст "([^"]*)"$/) do |text|
  query = find("//input[@name='q']")
  query.set(text)
  query.native.send_keys(:enter)
  $logger.info('Поисковый запрос отправлен')
  sleep 1
end

When(/^кликаю по строке выдачи с адресом (.+?)$/) do |url|
  link_first = find("//a[@href='#{url}/']/h3")
  link_first.click
  $logger.info("Переход на страницу #{url} осуществлен")
  sleep 1
end

When(/^я должен увидеть текст на странице "([^"]*)"$/) do |text_page|
  sleep 1
  expect(page).to have_text text_page
end

When(/^кликаю по кнопке "([^"]*)"$/) do |text|
  link_first = first("//a[text()='#{text}']")
  link_first.click
  $logger.info("Переход на страницу #{text} осуществлен")
  sleep 1
end

When(/^кликаю по первой ссылке после заголовка "([^"]*)"$/) do |text|
  link_first=first("//li[strong[text()[contains(.,'#{text}')]]]//a")
  link_first.click
  $logger.info("Загрузка файла начата")
  sleep 20
end

Then(/^проверяю наличие файла "(.+?)"$/) do |name|

file_name = File.exist?("/tmp/#{name}")
puts file_name
  if file_name == true
    $logger.info("Файл загружен")
  else
    $logger.info("Файл не загружен")
  end
  sleep 1
end

Then(/^проверяю наличие файла скачанного по ссылке после заголовка "([^"]*)" в папке "([^"]*)"$/) do |name, link|
  first_link = File.basename(first("//li[strong[text()[contains(.,'#{name}')]]]//a")[:href])
  file_name = Dir.pwd+link+first_link
  e_file = File.exist?(file_name)
  if e_file == true
    $logger.info("Стабильная версия загружена в папку #{link}")
  else
    $logger.info("Файл не загружен")
  end
  sleep 1
end


