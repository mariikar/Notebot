require_relative 'abilities'

module PushNoteBot
  # Класс основого процесса бота.
  class MainProcess
    MAIN_COMMANDS = %w[/all /delete /add /random].freeze

    attr_reader :token

    def initialize(token, abilities = Abilities)
      @token = token
      @abilities = abilities
    end

    def run!
      Telegram::Bot::Client.run(token) do |bot|
        bot.listen do |message|
          case message.text
          when '/all'
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "#{message.from.first_name}.\n #{all}"
            )
          when '/delete'
            bot.listen do |delete_message|
              if delete_message.chat.id == message.chat.id
                if delete(delete_message.text)
                  bot.api.send_message(
                    chat_id: message.chat.id,
                    text: "#{message.from.first_name}.\n Удалено: #{delete_message.text}"
                  )
                  bot.api.send_message(
                    chat_id: message.chat.id,
                    text: "#{message.from.first_name}.\n #{all}"
                  )
                else
                  bot.api.send_message(
                    chat_id: message.chat.id,
                    text: "#{message.from.first_name}.\n Не удалось удалить #{delete_message.text}"
                  )
                end
              else
                bot.api.send_message(
                  chat_id: message.chat.id,
                  text: "Бот занят!"
                )
              end
            end
          when '/add'
            bot.listen do |text_message|
              if text_message.chat.id == message.chat.id
                add(text_message.text)
                bot.api.send_message(
                  chat_id: message.chat.id,
                  text: "#{message.from.first_name}.\n #{all}"
                )
              else
                bot.api.send_message(
                  chat_id: message.chat.id,
                  text: "Бот занят!"
                )
              end
            end
          when '/random'
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "#{message.from.first_name}.\n #{random_note}"
            )
          else
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "Не правильный ввод"
            )
          end
        end
      end
    end

    def all
      notes.sample
    end

    def random(id)
      Abilities.
    end

    def all
      notes.join('\n')
    end

    def delete(text)
      notes.delete text
    end
  end
end
