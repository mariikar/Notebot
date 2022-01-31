require 'lib/push_note_bot.rb'
# require_relative запросит файл из той же папки что и этот. Не потребуется писать полный путь.
require_relative 'data_manager'

module PushNoteBot
  # Класс умений бота.
  class Abilities
    attr_reader :bot, :data_manager

    # знакомая запись, да? Этот прием называется DI Dependency Injection, внедрение зависимости. Он хорош тем, что не
    # связывает наши два класса напрямую, например для тестирования мы можем создать малленький класс пустышку который будет
    # возвращать только то что нам нужно для тестирования этого, а еще мы сможем использховать этот же класс для допустим работы с базой данных,
    # достаточно будет подсунуть сюда
    #   Abilities.new(bot, DataBaseManager.new)
    # в котором будут те же методы чтобы класс Abilities не запутался и всё! Если ты помнишь то мы можем положить в переменную что угодно,
    # хоть константу класса хоть его экземпляр (.new)
    def initialize(bot, data_manager = DataManager.new)
      @bot = bot
      @data_manager = data_manager
    end

    def random_note_with_users(id)
      all_notes_with_users_by(id).sample
    end

    def add_users_note(id, note_string)
      data_manager.write_users_note(id, note_string)
    end

    def all_notes_with_users_by(id)
      data_manager.default_notes + data_manager.notes_by_user(id)
    end

    def delete_users_note(id, note_string)
      data_manager.delete_users_note(id, note_string)
    end
  end
end
