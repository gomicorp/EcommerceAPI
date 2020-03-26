# companies = [
#   {
#     name: '(주) 고미코퍼레이션'
#   },
#   {
#     name: '(주) GS퍼시픽',
#     brands: [
#       {
#         name: 'BOOKKI', eng_name: 'BOOKKI',
#         products: [
#           {
#             title: 'BOOKKI 24K 골드 시그니처 프리미엄 앰플', price: 99000,
#             options: [
#               { name: '60mm(기본)', additional_price: 0 },
#               { name: '120mm', additional_price: 1_000 }
#             ]
#           }
#         ]
#       }
#     ]
#   },
#   {
#     name: '(주) 미펙토리',
#     brands: [
#       {
#         name: '바디홀릭', eng_name: 'Bodyholic',
#         products: [
#           {
#             title: '바디홀릭 스카이', price: 9900,
#             options: [
#               { name: '기본', additional_price: 0 }
#             ]
#           }
#         ]
#       }
#     ]
#   },
#   {
#     name: '(주) 버디네트웍스',
#     brands: [
#       {
#         name: '듀이셀', eng_name: 'Dewycel',
#         products: []
#       }
#     ]
#   }
# ]

# companies.each do |company_data|
#   company = Company.find_or_create_by(name: company_data[:name])
#   next if !company_data[:brands] || company_data[:brands].empty?

#   company_data[:brands].each do |brand_data|
#     brand = Brand.find_or_create_by(
#       company: company,
#       name: brand_data[:name],
#       eng_name: brand_data[:eng_name]
#     )
#     next if !brand_data[:products] || brand_data[:products].empty?

#     brand_data[:products].each do |product_data|
#       product = Product.find_or_create_by(
#         brand: brand,
#         title: product_data[:title],
#         price: product_data[:price]
#       )
#       next if !product_data[:options] || product_data[:options].empty?

#       product_data[:options].each do |product_option_data|
#         option = ProductOption.find_or_create_by(
#           product: product,
#           name: product_option_data[:name],
#           additional_price: product_option_data[:additional_price]
#         )

#         barcode_count = 10
#         next if barcode_count.zero?

#         barcode_count.times do |i|
#           barcode = Barcode.new
#           barcode.product = product
#           barcode.product_options << option
#           barcode.save
#         end
#       end
#     end
#   end
# end

# Country 튜플 예제
#Country.create!([
#  { name: 'vietnam', short_name: :vn, name_ko: '베트남', locale: :vi },
#  { name: 'thailand', short_name: :th,  name_ko: '태국', locale: :th }
#])
