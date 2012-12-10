module PostsHelper
  def nice_time(time)
    time.strftime '%A, %B %-d, %Y'
  end
end
