module BinaryTee
  class Create < ActiveInteraction::Base
    string :text
    file :image
    string :type

    validates :type, inclusion: { in: %w[dark light] }

    # C4C4C4
    DARK_FONTS = [
      'Mint', 'Soft Pink', 'Ash', 'Heather Ice Blue', 'Heather Peach', 'Pink', 'Light Blue',
      'Athletic Heather', 'Gold', 'Silver', 'Yellow'
    ]

    def execute
      # upload image
      file = Printer.upload(text: text, file: image)

      if file['status'] == 'error'
        errors.add(file)
      else
        # do we create 1 product per font color?
      end
    end

    def variants
      @variants ||= Printer.list_variants.select do |variant|
        if type == 'dark'
          DARK_FONTS.include?(variant.dig('options', 'color'))
        else
          DARK_FONTS.exclude?(variant.dig('options', 'color'))
        end
      end
    end

    class Failure
      attr_reader :error

      def initialize(error)
        @error = error
      end

      def success?
        false
      end
    end
  end
end
