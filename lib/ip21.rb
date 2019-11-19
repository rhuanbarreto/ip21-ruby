# frozen_string_literal: true

# Aspentech IP21 Adapter for executing queries using SQLPlus
#
# This library uses Windows Authentication for connecting to SQLPlus
#
# @author Rhuan Barreto
#
# @example
#   IP21.new(
#     auth: {
#       account: 'john.doe',
#       domain: 'contoso.com',
#       password: 'set_your_own_password'
#     },
#     sqlplus_address: '127.0.0.1',
#     ip21_address: '127.0.0.1',
#   ).query('SELECT IP_PLANT_AREA, Name, IP_DESCRIPTION FROM IP_AnalogDef')
class IP21
  # Initializes the connection
  #
  # @param [Hash] auth The Windows account, domain and password for connecting
  #   to SQLPLus
  # @param [String] sqlplus_address The hostname or IP address for connecting
  #   to SQLPlus
  # @param [String] ip21_address The hostname or IP address for connecting to
  #   the IP21 Database
  # @param [Boolean] soap Set this parameter to true for connecting to SQLPlus
  #   using the SOAP Web Service
  # @param [Boolean] debug Set this parameter to true for enabling debug
  #   information
  def initialize(
    auth: {
      account: 'john.doe',
      domain: 'contoso.com',
      password: 'set_your_own_password'
    },
    sqlplus_address: '127.0.0.1',
    ip21_address: '127.0.0.1',
    soap: false,
    debug: false
  )
    @account = auth[:account]
    @domain = auth[:domain]
    @password = auth[:password]
    @sqlplus_address = sqlplus_address
    @ip21_address = ip21_address
    @soap = soap
    @debug = debug
  end

  # Executes a direct query againt the database
  #
  # @param [String] sql The query to be executed
  # @param [Integer] limit The maximum number of rows that the query will output
  #
  # @return [Hash] Response from the query
  def query(sql, limit = 100, type = 'SQL')
    @soap ? soap(sql) : rest(sql, limit, type)
  end

  private

  def soap(sql)
    require 'savon'
    client = Savon.client(
      wsdl: soap_address,
      ntlm: [@account, @password, @domain],
      env_namespace: :soap,
      namespace_identifier: nil
    )
    client.call(:execute_sql, message: { command: sql }).body
  end

  def rest(sql, limit, type)
    response = rest_request(
      rest_address(type), query_body(sql, limit, type)
    )
    parse_rest(response)
  end

  def rest_request(url, body)
    require 'net/http'
    require 'ntlm/http'
    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri)
    request.body = body
    request.ntlm_auth(@account, @domain, @password)
    response = http.request(request)
    debug_info(url, request.body, response) if @debug
    response
  end

  def debug_info(address, body, response)
    puts "Request: #{address}"
    puts "Body: #{body}"
    puts "Response: #{response.body}"
  end

  def parse_rest(response)
    if response.code == '200'
      require 'json'
      JSON.parse(response.body)
    else
      {
        status: response.code,
        message: "Error on IP21: #{response.message}"
      }
    end
  end

  def soap_address
    "http://#{@sqlplus_address}/SQLplusWebService/SQLplusWebService.asmx?WSDL"
  end

  def rest_address(type)
    "http://#{@sqlplus_address}/ProcessData/AtProcessDataREST.dll/#{type}"
  end

  def query_body(sql, limit, type)
    case type
    when 'SQL'
      "<SQL c=\"DRIVER={AspenTech SQLplus};HOST=#{@ip21_address};Port=10014;" \
      "CHARINT=N;CHARFLOAT=N;CHARTIME=N;CONVERTERRORS=N;\" m=\"#{limit}\" " \
      "to=\"30\" s=\"#{select?(sql) ? 1 : 0}\"><![CDATA[#{sql}]]></SQL>"
    when 'KPI'
      require 'active_support'
      require 'active_support/core_ext/object/to_query'
      sql.to_query
    end
  end

  def select?(query)
    /^select/i.match?(query)
  end
end
