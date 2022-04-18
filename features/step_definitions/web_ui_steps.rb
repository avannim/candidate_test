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

When(/^кликаю по кнопке с адресом "(.+?)"$/) do |url|
  link_first = find("//a[@href='#{url}/']/div")
  link_first.click
  $logger.info("Переход на страницу #{url} осуществлен")
  sleep 1
end

When(/^кликаю по первой ссылке содержащей "(.+?)"$/) do |url|
  link_first = find("//a[contains(@href,'#{url}/'][1]/div")
  link_first.click
  $logger.info("Загрузка файла начата")
  sleep 1
end

When(/^проверяю наличие файла "(.+?)"$/) do |name|
  if File.exist?(name)
    $logger.info("Файл загружен")
  else
    $logger.info("Файл не загружен")
  end
  sleep 1
end

When(/^проверяю соответствие имени скачанного файла "(.+?)" с именем файла по ссылке "(.+?)" на сайте$/) do |name, site_name|
  file_name = name
  sname = File.readlink(site_name)
  if file_name == sname
    $logger.info("Загружена стабильная версия")
  else
    $logger.info("Загружена не верный файл")
  end
  sleep 1
end
