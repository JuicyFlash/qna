class SearchController < ApplicationController

  def show
    @search_result = search
  end

  private

  def search
    class_for_search.search(query_from_params)
  end

  def query_from_params
    return split_params[1..].join(':').gsub('@', '\@') if have_class_in_params? && split_params.length > 1

    params[:query].gsub('@', '\@')
  end

  def class_for_search
    return classes[class_from_params] if have_class_in_params?

    ThinkingSphinx
  end

  def class_from_params
    split_params[0].downcase
  end

  def split_params
    params[:query].split(':')
  end

  def have_class_in_params?
    !classes[class_from_params].nil?
  end

  def classes
    { 'question' => Question,
      'answer' => Answer,
      'comment' => Comment,
      'user' => User }
  end
end
