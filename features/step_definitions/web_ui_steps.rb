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

file_name = File.file?(name)
  if file_name = true
    $logger.info("Файл загружен")
  else
    $logger.info("Файл не загружен")
  end
  sleep 1
end

Then(/^проверяю наличие файла скачанного по ссылке после заголовка "([^"]*)" в папке "([^"]*)"$/) do |name, link|
  first_link = first("//li[strong[text()[contains(.,'#{name}')]]]//a")[:href]
  file_name = File.basename(first_link)
  e_file = File.exist?(link+file_name)
  if e_file = true
    $logger.info("Стабильная версия загружена в папку #{link}")
  else
    $logger.info("Файл не загружен")
  end
  sleep 1
end


When(/^проверяю соответствие имени скачанного файла "(.+?)" с именем файла по ссылке после заголовка "([^"]*)"$/) do |name, text|
  file_name = name
  element = first("//li[strong[text()[contains(.,'#{text}')]]]//a")[:href]
  sname = element.include?("#{file_name}")
  if sname = true
    $logger.info("Загружена стабильная версия")
  else
    $logger.info("Загружен не верный файл")
  end
  sleep 1
end
