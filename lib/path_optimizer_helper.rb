def p(text)
  Kernel::p text if /^debug$/i === ARGV[0]
end