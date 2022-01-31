require 'telegram/bot'

class PushNoteBot
  attr_reader :token
  attr_accessor :notes

  NOTES =
    [
      "Сколько лет вы собираетесь прожить?",
      "Во сколько лет наступит ваша старость?",
      "Как влияет на ваше здоровье ваша работа?",
      "Как влияет на ваше здоровье ваш образ жизни?",
      "Как влияет на ваше здоровье ваша система питания (пития, курения)",
      "Как влияет на ваше здоровье отношения с близкими людьми?",
      "Как влияет на ваше здоровье место, где вы живете?"
    ].freeze

  def initialize(token)
    @token = token
    @notes = NOTES.dup
  end

  def run!
    ::Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        @chat_id = message.chat.id

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
              break
              else
                bot.api.send_message(
                  chat_id: message.chat.id,
                  text: "#{message.from.first_name}.\n Не удалось удалить #{delete_message.text}"
                  )
              end
            break
            else
              bot.api.send_message(
                chat_id: @chat_id,
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
            break
            else
              bot.api.send_message(
                chat_id: @chat_id,
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
  rescue StandardError => e
    bot.api.send_message(
      chat_id: @chat_id,
      text: "Не правильный ввод"
      )
  end

  def random_note
    notes.sample
  end

  def add(text)
    notes << text
  end

  def all
    notes.join("\n")
  end

  def delete(text)
    notes.delete text
  end
end




class PushNoteBot
  attr_reader :token
  attr_accessor :notes

  NOTES =
    [
      "Сколько лет вы собираетесь прожить?",
      "Во сколько лет наступит ваша старость?",
      "Как влияет на ваше здоровье ваша работа?",
      "Как влияет на ваше здоровье ваш образ жизни?",
      "Как влияет на ваше здоровье ваша система питания (пития, курения)",
      "Как влияет на ваше здоровье отношения с близкими людьми?",
      "Как влияет на ваше здоровье место, где вы живете?"
    ].freeze

  def initialize(token)
    @token = token
    @notes = NOTES
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

  def random_note
    notes.sample
  end

  def add(text)
    notes << text
  end

  def all
    notes.join('\n')
  end

  def delete(text)
    notes.delete text
  end
end

=================================================

class DataManager
  def initialize(path)
    @path = path
  end

  def write_to_file(data)
    file.write "text#{$/}"
  rescue IOError => e
    retry
  ensure
    file.close unless file.nil?
  end

  def notes_by(user)
    {}
  end

  def default_notes

  end

  private

  def file(method_name)
    @file ||= File.open(path, 'a')
  end

  def file_data
    @file_data ||= file.readlines
    file.close
    @file_data
end
