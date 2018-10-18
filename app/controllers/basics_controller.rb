require 'nokogiri'
require 'open-uri'
require 'openssl'


class BasicsController < ApplicationController


  helper_method :cookies

  $quote_id = []

  def quotations
    if params[:quotation]

      temp = quote_params
      if temp[:category].blank?
        temp[:category] = temp[:new_category]
      end
      @quotation = Quotation.new temp




      #@quotation = Quotation.new temp
      if @quotation.save
        flash[:notice] = 'Quotation was successfully created.'
        @quotation = Quotation.new
      end
    else
      @quotation = Quotation.new
    end
    if !cookies[:key].nil?
      del_id_array = cookies.permanent[:key].split(%r{,\s*}).map(&:to_i)
    else
      del_id_array = nil
    end
    if params[:sort_by] == "date"
      @quotations = Quotation.where.not(id: del_id_array).order(:created_at)
    else
      @quotations = Quotation.where.not(id: del_id_array).order(:category)
    end
    @categories = Quotation.select(:category).distinct
  end

  def index
  end



  def search
    quote = params[:quote]
    if params[:quote]
      @quotations = Quotation.where('lower(quote) LIKE ?', "%#{params[:quote].downcase}%")
                        .or(Quotation.where('lower(author_name) LIKE ?', "%#{params[:quote].downcase}%"))
      if $quote_id.any?
        for id in $quote_id
          @quotations = @quotations.reject {|q| q.id = id}
        end
      end

    else
      @quotations = Quotation.all
    end

    @categories = Quotation.select(:category).distinct
    @quotation = Quotation.new
    render 'quotations'
  end

  def erase
    cookies.delete :key
    $quote_id.clear
    @quotations = Quotation.all
    @quotation = Quotation.new
    @categories = Quotation.select(:category).distinct
    render 'quotations'
  end

  def kill
    id = params[:id]
    if cookies.permanent[:key].nil?
      cookies.permanent[:key]=''
    end


    cookies.permanent[:key] = cookies.permanent[:key] + "#{id},"
    del_id = cookies.permanent[:key].split(%r{,\s*})
    del_id_array = del_id.map(&:to_i)
    $quote_id = del_id_array
    @quotations = Quotation.where.not(id: del_id_array)
    @quotation = Quotation.new
    @categories = Quotation.select(:category).distinct
    render 'quotations'
  end

  def divbyzero
     logger.error("About to divide by zero")
     a =1 /0
  end

  def news
    base_url = 'https://news.google.com/topics/CAAqJggKIiBDQkFTRWdvSUwyMHZNRFZxYUdjU0FtVnVHZ0pWVXlnQVAB'
    doc = Nokogiri::HTML(open(base_url,ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    @entries = doc.css('h2.OJMBqe').text
    @img  = doc.css('figure.AZtY5d.d7hoq.WylPad.QolzWc img')
    @src = @img.each { |l| l.attr('src') }
    @link = doc.css('div.ZulkBc.qNiaOd h3 a span').text
    @link = @link.split(',')

    render template: 'basics/news'
  end

  def exportXML
    @quotations = Quotation.all
    send_data @quotations.to_xml,
              type: 'text/xml; charset=UTF-8;',
              disposition: "attachment; filename=quotations.xml"
  end


  def exportJSON
    cookies[:key] = nil
    @quotations = Quotation.all
    send_data @quotations.to_json,
              type: 'text/json; charset=UTF-8;',
              disposition: "attachment; filename=quotations.json"
  end

  def import
    require 'open-uri'
    file = params[:import]
    root = Nokogiri::XML(open(file))
    quotations = root.xpath("quotations/quotation")
    quotations.each do |quotation|
      quotation_hash = {
          author_name: quotation.at_xpath("author-name").text,
          category:  quotation.at_xpath("category").text,
          quote: quotation.at_xpath("quote").text
      }
      quotation_record = Quotation.create!(quotation_hash)
      quotation_record.save
    end
    @quotations = Quotation.all
    @quotation = Quotation.new
    @categories = Quotation.select(:category).distinct
    render 'quotations'
  end

  private

  def quote_params
    params.require(:quotation).permit(:author_name,:category,:new_category, :quote)
  end



end
