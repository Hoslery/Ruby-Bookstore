# frozen_string_literal: true

require 'date'
require 'forme'
require 'roda'

require_relative 'models'

# The application class
class BookShopApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :render
  plugin :multibyte_string_matcher
  plugin :status_handler

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  opts[:books] = Reader.read_books
  opts[:supplies] = Reader.read_supplies
  opts[:shopList] = {}
  opts[:file] = []

  status_handler(404) do
    view('not_found')
  end

  route do |r|
    r.public if opts[:serve_static]

    r.root do
      r.redirect '/shop'
    end

    r.on 'shop' do
      r.is do
        @parameters = DryResultFormeWrapper.new(SearchFilterFormSchema.call(r.params))
        @books = if @parameters.success?
                   opts[:books].filter(@parameters[:s_title], @parameters[:s_genre]).values
                 else
                   opts[:books].all_books
                 end
        @supplies = opts[:supplies].all_supplies
        view('shop')
      end

      r.on 'add_book' do
        r.get do
          @parameters = {}
          view('add_book')
        end

        r.post do
          @parameters = DryResultFormeWrapper.new(BookNewFormSchema.call(r.params))
          if @parameters.success?
            opts[:books].add_book_user(@parameters)
            r.redirect '/shop'
          else
            view('add_book')
          end
        end
      end

      r.on 'add_sup' do
        r.get do
          @parameters = {}
          view('add_sup')
        end

        r.post do
          @parameters = DryResultFormeWrapper.new(SupNewFormSchema.call(r.params))
          if @parameters.success?
            opts[:supplies].add_supplies_user(@parameters)
            r.redirect '/shop'
          else
            view('add_sup')
          end
        end
      end

      r.on 'genre_stat' do
        r.is do
          @books = opts[:books]
          @genres = @books.genres
          @supplies = opts[:supplies]
          view('genre_stat')
        end
      end

      r.on 'delete_book' do
        r.on Integer do |book_id|
          @book = opts[:books].book_by_id(book_id)
          r.get do
            @parameters = {}
            view('delete_book')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(ProductDeleteSchema.call(r.params))
            if @parameters.success?
              opts[:books].delete_book(@book.id)
              r.redirect('/shop')
            else
              view('delete_book')
            end
          end
        end
      end

      r.on 'delete_sup' do
        r.on Integer do |sup_id|
          @sup = opts[:supplies].sup_by_id(sup_id)
          r.get do
            @parameters = {}
            view('delete_sup')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(ProductDeleteSchema.call(r.params))
            if @parameters.success?
              opts[:supplies].delete_sup(@sup.id)
              r.redirect('/shop')
            else
              view('delete_sup')
            end
          end
        end
      end

      r.on 'list' do
        r.is do
          @books = opts[:books]
          @supplies = opts[:supplies]
          @shop_list = opts[:shopList]
          view('list')
        end

        r.on 'add_list_book' do
          r.get do
            @parameters = {}
            @books = opts[:books].all_title
            view('add_list_book')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(ListProductFormSchema.call(r.params))
            if @parameters.success?
              if opts[:shopList][@parameters[:title]].nil?
                opts[:shopList][@parameters[:title]] = 1
              else
                opts[:shopList][@parameters[:title]] += 1
              end
              r.redirect('/shop/list')
            else
              @books = opts[:books].all_title
              view('add_list_book')
            end
          end
        end

        r.on 'add_list_sup' do
          r.get do
            @parameters = {}
            @supplies = opts[:supplies].all_title
            view('add_list_sup')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(ListProductFormSchema.call(r.params))
            if @parameters.success?
              if opts[:shopList]["#{@parameters[:title]}_sup"].nil?
                opts[:shopList]["#{@parameters[:title]}_sup"] = 1
              else
                opts[:shopList]["#{@parameters[:title]}_sup"] += 1
              end
              r.redirect('/shop/list')
            else
              @supplies = opts[:supplies].all_title
              view('add_list_sup')
            end
          end
        end

        r.on 'delete_product' do
          r.on String do |title|
            r.get do
              @parameters = {}
              view('delete_product')
            end

            r.post do
              @parameters = DryResultFormeWrapper.new(ProductDeleteSchema.call(r.params))
              if @parameters.success?
                opts[:shopList].delete(title)
                r.redirect('/shop/list')
              else
                view('delete_product')
              end
            end
          end
        end

        r.on 'delete_list' do
          r.get do
            @parameters = {}
            view('delete_list')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(ProductDeleteSchema.call(r.params))
            if @parameters.success?
              opts[:shopList].clear
              r.redirect('/shop')
            else
              view('delete_list')
            end
          end
        end

        r.on 'pay_for_list' do
          r.get do
            @parameters = {}
            view('pay_for_list')
          end

          r.post do
            @parameters = DryResultFormeWrapper.new(FileNameFormSchema.call(r.params))
            if @parameters.success?
              Writer.write_list(@parameters[:file_name], opts[:shopList], opts[:books],
                                opts[:supplies])
              opts[:books].recalculating_list(opts[:shopList])
              opts[:supplies].recalculating_list(opts[:shopList])
              opts[:shopList].clear
              opts[:file].append(@parameters[:file_name])
              r.redirect('/shop')
            else
              view('pay_for_list')
            end
          end
        end

        r.on 'paid' do
          r.is do
            @files = opts[:file]
            view('paid')
          end
        end
      end
    end
  end
end
