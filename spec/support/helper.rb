require 'webmock/rspec'


def a_delete(path, endpoint='https://api.active.com')
  a_request(:delete, endpoint + path)
end

def a_get(path, endpoint='https://api.active.com')
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint='https://api.active.com')
  a_request(:post, endpoint + path)
end

def a_put(path, endpoint='https://api.active.com')
  a_request(:put, endpoint + path)
end

def stub_delete(path, endpoint='https://api.active.com')
  stub_request(:delete, endpoint + path)
end

def stub_get(path, endpoint='https://api.active.com')
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint='https://api.active.com')
  stub_request(:post, endpoint + path)
end

def stub_put(path, endpoint='https://api.active.com')
  stub_request(:put, endpoint + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

