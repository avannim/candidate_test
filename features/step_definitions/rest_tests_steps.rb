# frozen_string_literal: true

When(/^получаю информацию о пользователях$/) do
  users_full_information = $rest_wrap.get('/users')

  $logger.info('Информация о пользователях получена')
  @scenario_data.users_full_info = users_full_information
end

When(/^проверяю (наличие|отсутствие) логина (\w+\.\w+) в списке пользователей$/) do |presence, login|
  search_login_in_list = true
  presence == 'отсутствие' ? search_login_in_list = !search_login_in_list : search_login_in_list

  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)

  if login_presents
    message = "Логин #{login} присутствует в списке пользователей"
    search_login_in_list ? $logger.info(message) : raise(message)
  else
    message = "Логин #{login} отсутствует в списке пользователей"
    search_login_in_list ? raise(message) : $logger.info(message)
  end
end

When(/^добавляю пользователя c логином (\w+\.\w+) именем (\w+) фамилией (\w+) паролем ([\d\w@!#]+)$/) do
|login, name, surname, password|

  response = $rest_wrap.post('/users', login: login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: 1)
  $logger.info(response.inspect)
end

When(/^добавляю пользователя с параметрами:$/) do |data_table|
  user_data = data_table.raw

  login = user_data[0][1]
  name = user_data[1][1]
  surname = user_data[2][1]
  password = user_data[3][1]

  step "добавляю пользователя c логином #{login} именем #{name} фамилией #{surname} паролем #{password}"
end

When(/^нахожу пользователя с логином (\w+\.\w+)$/) do |login|
  step %(получаю информацию о пользователях)
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end

  $logger.info("Найден пользователь #{login} с id:#{@scenario_data.users_id[login]}")
end

When(/^удаляю пользователя c логином (\w+\.\w+)$/) do |login|
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                       .users_full_info,
                                                  user_login: login)
  end
  id=@scenario_data.users_id[login]
  response = $rest_wrap.delete('/users/'+"#{id}")
  $logger.info(response.inspect)
end

When(/^пользователю c логином (\w+\.\w+) передаю имя (\w+) фамилию (\w+)$/) do
|login, name, surname|
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                       .users_full_info,
                                                  user_login: login)
  end
  id=@scenario_data.users_id[login]
  response = $rest_wrap.put('/users/'+"#{id}", name: name,
                             surname: surname,
                             active: 1)
  $logger.info(response.inspect)
end

When(/^нахожу пользователя с логином (\w+\.\w+) с именем (\w+) фамилией (\w+)$/) do |login, name, surname|
  users_name = 0
  users_surname = 0
  @scenario_data.users_full_info.each do |user|
    next unless user['login'] == login
    if user['login'] == login
      users_name = user['name']
      users_surname = user['surname']
    end
  end

  if users_name == name && users_surname == surname
    $logger.info("Логин #{login} с именем #{name} фамилией #{surname} присутствует в списке пользователей")
    else
      $logger.info("Логин #{login} с именем #{name} фамилией #{surname} отсутствует в списке пользователей")
    end
end
