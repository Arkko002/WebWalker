#TODO Test C binding, does it work?
@[Link("libpostal")]
lib LibPostal
  fun address_parser_parse(adress : Char*, language : Char* , country : Char*)
end
