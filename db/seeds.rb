# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#####################
## Types
#####################
puts "Loading Types"
StoryType.delete_all
StoryTypeTranslation.delete_all
t = StoryType.create(:id => 1, :sort_order => 3)
t.story_type_translations.create(:locale => 'en', :name => 'Story')
t.story_type_translations.create(:locale => 'ka', :name => 'Story')
t.story_type_translations.create(:locale => 'ru', :name => 'Story')
t.story_type_translations.create(:locale => 'az', :name => 'Story')
t.story_type_translations.create(:locale => 'hy', :name => 'Story')
t = StoryType.create(:id => 2, :sort_order => 4)
t.story_type_translations.create(:locale => 'en', :name => 'Talk Show')
t.story_type_translations.create(:locale => 'ka', :name => 'Talk Show')
t.story_type_translations.create(:locale => 'ru', :name => 'Talk Show')
t.story_type_translations.create(:locale => 'az', :name => 'Talk Show')
t.story_type_translations.create(:locale => 'hy', :name => 'Talk Show')
t = StoryType.create(:id => 3, :sort_order => 2)
t.story_type_translations.create(:locale => 'en', :name => 'Video')
t.story_type_translations.create(:locale => 'ka', :name => 'Video')
t.story_type_translations.create(:locale => 'ru', :name => 'Video')
t.story_type_translations.create(:locale => 'az', :name => 'Video')
t.story_type_translations.create(:locale => 'hy', :name => 'Video')
t = StoryType.create(:id => 4, :sort_order => 1)
t.story_type_translations.create(:locale => 'en', :name => 'Photo')
t.story_type_translations.create(:locale => 'ka', :name => 'Photo')
t.story_type_translations.create(:locale => 'ru', :name => 'Photo')
t.story_type_translations.create(:locale => 'az', :name => 'Photo')
t.story_type_translations.create(:locale => 'hy', :name => 'Photo')
# t = StoryType.create(:id => 5, :sort_order => 5)
# t.story_type_translations.create(:locale => 'en', :name => 'Infographic')
# t.story_type_translations.create(:locale => 'ka', :name => 'Infographic')
# t.story_type_translations.create(:locale => 'ru', :name => 'Infographic')
# t.story_type_translations.create(:locale => 'az', :name => 'Infographic')
# t.story_type_translations.create(:locale => 'hy', :name => 'Infographic')


#####################
## Languages
#####################
puts 'loading languages'
  Language.delete_all
  langs = [
    ["af", "Afrikaans"],
    ["sq", "shqipe"],
    ["ar", "العربية‏"],
    ["hy", "Հայերեն"],
    ["az", "Azərbaycan­ılı"],
    ["eu", "euskara"],
    ["be", "Беларускі"],
    ["bg", "български"],
    ["ca", "català"],
    ["hr", "hrvatski"],
    ["cs", "čeština"],
    ["da", "dansk"],
    ["div", "ދިވެހިބަސް‏"],
    ["nl", "Nederlands"],
    ["en", "English"],
    ["et", "eesti"],
    ["fo", "føroyskt"],
    ["fi", "suomi"],
    ["fr", "français"],
    ["gl", "galego"],
    ["ka", "ქართული"],
    ["de", "Deutsch"],
    ["el", "ελληνικά"],
    ["gu", "ગુજરાતી"],
    ["he", "עברית‏"],
    ["hi", "हिंदी"],
    ["hu", "magyar"],
    ["is", "íslenska"],
    ["id", "Bahasa Indonesia"],
    ["it", "italiano"],
    ["ja", "日本語"],
    ["kn", "ಕನ್ನಡ"],
    ["kk", "Қазащb"],
    ["sw", "Kiswahili"],
    ["kok", "कोंकणी"],
    ["ko", "한국어"],
    ["ky", "Кыргыз"],
    ["lv", "latviešu"],
    ["lt", "lietuvių"],
    ["mk", "македонски јазик"],
    ["ms", "Bahasa Malaysia"],
    ["mr", "मराठी"],
    ["mn", "Монгол хэл"],
    ["no", "norsk"],
    ["fa", "فارسى‏"],
    ["pl", "polski"],
    ["pt", "Português"],
    ["pa", "ਪੰਜਾਬੀ"],
    ["ro", "română"],
    ["ru", "русский"],
    ["sa", "संस्कृत"],
    ["sr", "srpski"],
    ["sk", "slovenčina"],
    ["sl", "slovenski"],
    ["es", "español"],
    ["sv", "svenska"],
    ["syr", "ܣܘܪܝܝܐ‏"],
    ["ta", "தமிழ்"],
    ["tt", "Татар"],
    ["te", "తెలుగు"],
    ["th", "ไทย"],
    ["tr", "Türkçe"],
    ["uk", "україньска"],
    ["ur", "اُردو‏"],
    ["uz", "U'zbek"],
    ["vi", "Tiếng Việt"],
    ["zh-TW", "繁體中文"],
    ["zh-CN", "简体中文"]
  ]

  # only load the languages that the app is in.
  app_langs = []
  I18n.available_locales.each do |locale|
    app_langs << langs.select{|x| x[0] == locale.to_s}.first
  end
  app_langs.each{|lang|
    Language.create(locale: lang[0], name: lang[1])
  }
  # sql = "insert into languages (locale, name) values "
  # sql << app_langs.map{|x| "(\"#{x[0]}\", \"#{x[1]}\")"}.join(', ')
  # ActiveRecord::Base.connection.execute(sql)


puts 'loading countries'
  Country.delete_all
  CountryTranslation.delete_all
  countries = [
    { en: "Afghanistan", ka: "ავღანეთი" },
    { en: "Aland Islands", ka: "ალანდის კუნძულები" },
    { en: "Albania", ka: "ალბანეთი" },
    { en: "Algeria", ka: "ალჟირი" },
    { en: "American Samoa", ka: "ამერიკის სამოა" },
    { en: "Andorra", ka: "ანდორა" },
    { en: "Angola", ka: "ანგოლა" },
    { en: "Anguilla", ka: "ანგილია" },
    { en: "Antarctica", ka: "ანტარქტიდა" },
    { en: "Antigua and Barbuda", ka: "ანტიგუა და ბარბუდა" },
    { en: "Argentina", ka: "არგენტინა" },
    { en: "Armenia", ka: "სომხეთი" },
    { en: "Aruba", ka: "არუბა" },
    { en: "Australia", ka: "ავსტრალია" },
    { en: "Austria", ka: "ავსტრია" },
    { en: "Azerbaijan", ka: "აზერბაიჯანი" },
    { en: "Bahamas", ka: "ბაჰამის კუნძულები" },
    { en: "Bahrain", ka: "ბაჰრეინი" },
    { en: "Bangladesh", ka: "ბანგლადეში" },
    { en: "Barbados", ka: "ბარბადოსი" },
    { en: "Belarus", ka: "ბელარუსი" },
    { en: "Belgium", ka: "ბელგია" },
    { en: "Belize", ka: "ბელიზი" },
    { en: "Benin", ka: "ბენინი" },
    { en: "Bermuda", ka: "ბერმუდის კუნძულები" },
    { en: "Bhutan", ka: "ბჰუტანი" },
    { en: "Bolivia", ka: "ბოლივია" },
    { en: "Bonaire, Sint Eustatius and Saba", ka: "ბონეირი, სინტ-ესტატიუსი და საბა" },
    { en: "Bosnia and Herzegovina", ka: "ბოსნია და ჰერცეგოვინა" },
    { en: "Botswana", ka: "ბოტსვანა" },
    { en: "Bouvet Island", ka: "ბუვე" },
    { en: "Brazil", ka: "ბრაზილია" },
    { en: "British Indian Ocean Territory", ka: "ბრიტანეთის ტერიტორიები ინდოეთის ოკეანეში" },
    { en: "Brunei Darussalam", ka: "ბრუნეი დარუსალამი" },
    { en: "Bulgaria", ka: "ბულგარეთი" },
    { en: "Burkina Faso", ka: "ბურკინა-ფასო" },
    { en: "Burundi", ka: "ბურუნდი" },
    { en: "Cambodia", ka: "კამბოჯა" },
    { en: "Cameroon", ka: "კამერუნი" },
    { en: "Canada", ka: "კანადა" },
    { en: "Cabo Verde", ka: "კაბო-ვერდე" },
    { en: "Cayman Islands", ka: "კაიმანის კუნძულები" },
    { en: "Central African Republic", ka: "ცენტრალური აფრიკის რესპუბლიკა" },
    { en: "Chad", ka: "ჩადი" },
    { en: "Chile", ka: "ჩილე" },
    { en: "China", ka: "ჩინეთი" },
    { en: "Christmas Island", ka: "შობის კუნძული" },
    { en: "Cocos (Keeling) Islands", ka: "ქოქოსის კუნძულები" },
    { en: "Colombia", ka: "კოლუმბია" },
    { en: "Comoros", ka: "კომორის კუნძულების კავშირი" },
    { en: "Congo", ka: "კონგო" },
    { en: "Congo (Democratic Republic of the)", ka: "კონგოს დემოკრატიული რესპუბლიკა" },
    { en: "Cook Islands", ka: "კუკის კუნძულები" },
    { en: "Costa Rica", ka: "კოსტა-რიკა" },
    { en: "Cote d'Ivoire", ka: "კოტ-დ’ივუარი" },
    { en: "Croatia", ka: "ხორვატია" },
    { en: "Cuba", ka: "კუბა" },
    { en: "Curacao", ka: "კიურასაო" },
    { en: "Cyprus", ka: "კვიპროსი" },
    { en: "Czech Republic", ka: "ჩეხეთი" },
    { en: "Denmark", ka: "დანია" },
    { en: "Djibouti", ka: "ჯიბუტი" },
    { en: "Dominica", ka: "დომინიკა" },
    { en: "Dominican Republic", ka: "დომინიკელთა რესპუბლიკა" },
    { en: "Ecuador", ka: "ეკვადორი" },
    { en: "Egypt", ka: "ეგვიპტე" },
    { en: "El Salvador", ka: "სალვადორი" },
    { en: "Equatorial Guinea", ka: "ეკვატორული გვინეა" },
    { en: "Eritrea", ka: "ერიტრეა" },
    { en: "Estonia", ka: "ესტონეთი" },
    { en: "Ethiopia", ka: "ეთიოპია" },
    { en: "Falkland Islands (Malvinas)", ka: "ფოლკლენდის კუნძულები (მალვინები)" },
    { en: "Faroe Islands", ka: "ფარერის კუნძულები" },
    { en: "Fiji", ka: "ფიჯი" },
    { en: "Finland", ka: "ფინეთი" },
    { en: "France", ka: "საფრანგეთი" },
    { en: "French Guiana", ka: "საფრანგეთის გვიანა" },
    { en: "French Polynesia", ka: "საფრანგეთის პოლინეზია" },
    { en: "French Southern Territories", ka: "საფრანგეთის სამხრეთული და ანტარქტიდული ტერიტორია" },
    { en: "Gabon", ka: "გაბონი" },
    { en: "Gambia", ka: "გამბია" },
    { en: "Georgia", ka: "საქართველო" },
    { en: "Germany", ka: "გერმანია" },
    { en: "Ghana", ka: "განა" },
    { en: "Gibraltar", ka: "გიბრალტარი" },
    { en: "Greece", ka: "საბერძნეთი" },
    { en: "Greenland", ka: "გრენლანდია" },
    { en: "Grenada", ka: "გრენადა" },
    { en: "Guadeloupe", ka: "გვადელუპა" },
    { en: "Guam", ka: "გუამი" },
    { en: "Guatemala", ka: "გვატემალა" },
    { en: "Guernsey", ka: "გერნზი" },
    { en: "Guinea", ka: "გვინეა" },
    { en: "Guinea-Bissau", ka: "გვინეა-ბისაუ" },
    { en: "Guyana", ka: "გაიანა" },
    { en: "Haiti", ka: "ჰაიტი" },
    { en: "Heard Island and McDonald Islands", ka: "ჰერდი და მაკდონალდის კუნძულები" },
    { en: "Holy See", ka: "ვატიკანი (წმინდა საყდარი)" },
    { en: "Honduras", ka: "ჰონდურასი" },
    { en: "Hong Kong", ka: "ჰონგ-კონგი" },
    { en: "Hungary", ka: "უნგრეთი" },
    { en: "Iceland", ka: "ისლანდია" },
    { en: "India", ka: "ინდოეთი" },
    { en: "Indonesia", ka: "ინდონეზია" },
    { en: "Iran (Islamic Republic of)", ka: "ირანის მუსულმანური რესპუბლიკა" },
    { en: "Iraq", ka: "ერაყი" },
    { en: "Ireland", ka: "ირლანდია" },
    { en: "Isle of Man", ka: "კუნძული მენი" },
    { en: "Israel", ka: "ისრაელი" },
    { en: "Italy", ka: "იტალია" },
    { en: "Jamaica", ka: "იამაიკა" },
    { en: "Japan", ka: "იაპონია" },
    { en: "Jersey", ka: "ჯერზი" },
    { en: "Jordan", ka: "იორდანია" },
    { en: "Kazakhstan", ka: "ყაზახეთი" },
    { en: "Kenya", ka: "კენია" },
    { en: "Kiribati", ka: "კირიბატი" },
    { en: "Korea (Democratic People's Republic of)", ka: "ჩრდილოეთი კორეა" },
    { en: "Korea (Republic of)", ka: "სამხრეთი კორეა" },
    { en: "Kuwait", ka: "ქუვეითი" },
    { en: "Kyrgyzstan", ka: "ყირგიზეთი" },
    { en: "Lao People's Democratic Republic", ka: "ლაოსის სახალხო დემოკრატიული რესპუბლიკა" },
    { en: "Latvia", ka: "ლატვია" },
    { en: "Lebanon", ka: "ლიბანი" },
    { en: "Lesotho", ka: "ლესოთო" },
    { en: "Liberia", ka: "ლიბერია" },
    { en: "Libya", ka: "ლიბიის არაბული ჯამაჰირია" },
    { en: "Liechtenstein", ka: "ლიხტენშტაინი" },
    { en: "Lithuania", ka: "ლიტვა" },
    { en: "Luxembourg", ka: "ლუქსემბურგი" },
    { en: "Macao", ka: "მაკაო" },
    { en: "Macedonia (the former Yugoslav Republic of)", ka: "მაკედონია" },
    { en: "Madagascar", ka: "მადაგასკარი" },
    { en: "Malawi", ka: "მალავი" },
    { en: "Malaysia", ka: "მალაიზია" },
    { en: "Maldives", ka: "მალდივი" },
    { en: "Mali", ka: "მალი" },
    { en: "Malta", ka: "მალტა" },
    { en: "Marshall Islands", ka: "მარშალის კუნძულები" },
    { en: "Martinique", ka: "მარტინიკა" },
    { en: "Mauritania", ka: "მავრიტანია" },
    { en: "Mauritius", ka: "მავრიკი" },
    { en: "Mayotte", ka: "მაიოტა" },
    { en: "Mexico", ka: "მექსიკა" },
    { en: "Micronesia (Federated States of)", ka: "მიკრონეზიის ფედერაციული შტატები" },
    { en: "Moldova (Republic of)", ka: "მოლდოვას რესპუბლიკა" },
    { en: "Monaco", ka: "მონაკო" },
    { en: "Mongolia", ka: "მონღოლეთი" },
    { en: "Montenegro", ka: "ჩერნოგორია" },
    { en: "Montserrat", ka: "მონსერატი" },
    { en: "Morocco", ka: "მაროკო" },
    { en: "Mozambique", ka: "მოზამბიკი" },
    { en: "Myanmar", ka: "მიანმარი" },
    { en: "Namibia", ka: "ნამიბია" },
    { en: "Nauru", ka: "ნაურუ" },
    { en: "Nepal", ka: "ნეპალი" },
    { en: "Netherlands", ka: "ნიდერლანდი" },
    { en: "New Caledonia", ka: "ახალი კალედონია" },
    { en: "New Zealand", ka: "ახალი ზელანდია" },
    { en: "Nicaragua", ka: "ნიკარაგუა" },
    { en: "Niger", ka: "ნიგერი" },
    { en: "Nigeria", ka: "ნიგერია" },
    { en: "Niue", ka: "ნიუე" },
    { en: "Norfolk Island", ka: "ნორფოლკი (კუნძული)" },
    { en: "Northern Mariana Islands", ka: "ჩრდილოეთი მარიანას კუნძულები" },
    { en: "Norway", ka: "ნორვეგია" },
    { en: "Oman", ka: "ომანი" },
    { en: "Pakistan", ka: "პაკისტანი" },
    { en: "Palau", ka: "პალაუ" },
    { en: "Palestine, State of", ka: " პალესტინის ტერიტორიები, ოკუპირებული" },
    { en: "Panama", ka: "პანამა" },
    { en: "Papua New Guinea", ka: "პაპუა-ახალი გვინეა" },
    { en: "Paraguay", ka: "პარაგვაი" },
    { en: "Peru", ka: "პერუ" },
    { en: "Philippines", ka: "ფილიპინები" },
    { en: "Pitcairn", ka: "პიტკერნის კუნძულები" },
    { en: "Poland", ka: "პოლონეთი" },
    { en: "Portugal", ka: "პორტუგალია" },
    { en: "Puerto Rico", ka: "პუერტო-რიკო" },
    { en: "Qatar", ka: "კატარი" },
    { en: "Reunion", ka: "რეიუნიონი" },
    { en: "Romania", ka: "რუმინეთი" },
    { en: "Russian Federation", ka: "რუსეთი" },
    { en: "Rwanda", ka: "რუანდა" },
    { en: "Saint Barthelemy", ka: "სენ-ბართელმი" },
    { en: "Saint Helena, Ascension and Tristan da Cunha", ka: "წმინდა ელენეს კუნძული" },
    { en: "Saint Kitts and Nevis", ka: "სენტ-კიტსი და ნევისი" },
    { en: "Saint Lucia", ka: "სენტ-ლუსია" },
    { en: "Saint Martin (French part)", ka: "წმინდა მარტინი (საფრანგეთის ნაწილი)" },
    { en: "Saint Pierre and Miquelon", ka: "სენ-პიერი და მიკელონი" },
    { en: "Saint Vincent and the Grenadines", ka: "სენტ-ვინსენტი და გრენადინები" },
    { en: "Samoa", ka: "სამოა" },
    { en: "San Marino", ka: "სან-მარინო" },
    { en: "Sao Tome and Principe", ka: "სან-ტომე და პრინსიპი" },
    { en: "Saudi Arabia", ka: "საუდის არაბეთი" },
    { en: "Senegal", ka: "სენეგალი" },
    { en: "Serbia", ka: "სერბეთი" },
    { en: "Seychelles", ka: "სეიშელი" },
    { en: "Sierra Leone", ka: "სიერა-ლეონე" },
    { en: "Singapore", ka: "სინგაპური" },
    { en: "Sint Maarten (Dutch part)", ka: "სინტ-მარტენი" },
    { en: "Slovakia", ka: "სლოვაკეთი" },
    { en: "Slovenia", ka: "სლოვენია" },
    { en: "Solomon Islands", ka: "სოლომონის კუნძულები" },
    { en: "Somalia", ka: "სომალი" },
    { en: "South Africa", ka: "სამხრეთ აფრიკა" },
    { en: "South Georgia and the South Sandwich Islands", ka: "სამხრეთი გეორგია და სამხრეთ სენდვიჩის კუნძულები" },
    { en: "South Sudan", ka: "სამხრეთ სუდანი" },
    { en: "Spain", ka: "ესპანეთი" },
    { en: "Sri Lanka", ka: "შრი-ლანკა" },
    { en: "Sudan", ka: "სუდანი" },
    { en: "Suriname", ka: "სურინამი" },
    { en: "Svalbard and Jan Mayen", ka: "სვალბარდი და იან-მაიენი" },
    { en: "Swaziland", ka: "სვაზილენდი" },
    { en: "Sweden", ka: "შვედეთი" },
    { en: "Switzerland", ka: "შვეიცარია" },
    { en: "Syrian Arab Republic", ka: "სირიის არაბთა რესპუბლიკა" },
    { en: "Tanzania, United Republic of", ka: "ტანზანიის გაერთიანებული რესპუბლიკა" },
    { en: "Tajikistan", ka: "ტაჯიკეთი" },
    { en: "Taiwan, Province of China", ka: "ტაივანი" },
    { en: "Thailand", ka: "ტაილანდი" },
    { en: "Timor-Leste", ka: "აღმოსავლეთი ტიმორი" },
    { en: "Togo", ka: "ტოგო" },
    { en: "Tokelau", ka: "ტოკელაუ" },
    { en: "Tonga", ka: "ტონგა" },
    { en: "Trinidad and Tobago", ka: "ტრინიდადი და ტობაგო" },
    { en: "Tunisia", ka: "ტუნისი" },
    { en: "Turkey", ka: "თურქეთი" },
    { en: "Turkmenistan", ka: "თურქმენეთი" },
    { en: "Turks and Caicos Islands", ka: "ტერქსისა და კაიკოსის კუნძულები" },
    { en: "Tuvalu", ka: "ტუვალუ" },
    { en: "Uganda", ka: "უგანდა" },
    { en: "Ukraine", ka: "უკრაინა" },
    { en: "United Arab Emirates", ka: "არაბთა გაერთიანებული საამიროები" },
    { en: "United Kingdom of Great Britain and Northern Ireland", ka: "გაერთიანებული სამეფო" },
    { en: "United States of America", ka: "აშშ" },
    { en: "United States Minor Outlying Islands", ka: "აშშ-ის მიმდებარე მცირე კუნძულები" },
    { en: "Uruguay", ka: "ურუგვაი" },
    { en: "Uzbekistan", ka: "უზბეკეთი" },
    { en: "Vanuatu", ka: "ვანუატუ" },
    { en: "Venezuela (Bolivarian Republic of)", ka: "ვენესუელა" },
    { en: "Viet Nam", ka: "ვიეტნამი" },
    { en: "Virgin Islands (British)", ka: "ვირჯინის კუნძულები (ბრიტანეთის)" },
    { en: "Virgin Islands (U.S.)", ka: "ვირჯინის კუნძულები (აშშ-ის)" },
    { en: "Wallis and Futuna", ka: "უოლისი და ფუტუნა" },
    { en: "Western Sahara", ka: "დასავლეთი საჰარა" },
    { en: "Yemen", ka: "იემენი" },
    { en: "Zambia", ka: "ზამბია" },
    { en: "Zimbabwe", ka: "ზიმბაბვე" }
  ]

  countries.each{ |country|
    c = Country.create()
    [:en, :ka].each {|locale|
      c.country_translations.create(:locale => locale, :name => country[locale])
    }
  }


if !Rails.env.production?

  #####################
  ## Themes
  #####################
  puts "Loading Test/Dummy Data"
  Theme.delete_all
  ThemeTranslation.delete_all
  StoryTheme.delete_all

  # get stories to add to theme
  published_ids = StoryTranslation.select('distinct story_id').where(:published => true)
  published = Story.where(:id => published_ids.uniq)

  t = Theme.create(:id => 1, :published_at => '2015-01-15', :show_home_page => true)
  t.theme_translations.create(:locale => 'en', :name => '1st test theme', edition: 'January 2015')
  t.theme_translations.create(:locale => 'ka', :name => '1st test theme', edition: 'January 2015')
  published[0..7].each_with_index do |story, i|
    story.themes << t
    if i % 2 == 0
      story.in_theme_slider = true
    end
    story.save
  end
  t.is_published = true
  t.save

  t = Theme.create(:id => 2, :published_at => '2014-12-15')
  t.theme_translations.create(:locale => 'en', :name => '2nd test theme', edition: 'December 2014')
  t.theme_translations.create(:locale => 'ka', :name => '2nd test theme', edition: 'December 2014')
  # published[8..10].each_with_index do |story, i|
  #   story.themes << t
  #   if i % 2 == 0
  #     story.in_theme_slider = true
  #   end
  #   story.save
  # end
  t.is_published = true
  t.save


  t = Theme.create(:id => 3, :published_at => '2014-11-15')
  t.theme_translations.create(:locale => 'en', :name => '3rd test theme', edition: 'November 2015')
  t.theme_translations.create(:locale => 'ka', :name => '3rd test theme', edition: 'November 2015')
  # published[10..20].each_with_index do |story, i|
  #   story.themes << t
  #   if [1, 5, 9].include?(i)
  #     story.in_theme_slider = true
  #   end
  #   story.save
  # end
  t.is_published = true
  t.save


  # add story type to remaining stories
  # published[21..published.length-1].each do |story|
  #   story.save
  # end

  # clear out all existing story user roles if a person is a coordinator
  coords = User.where(:role => User::ROLES[:coordinator]).pluck(:id)
  StoryUser.where(:user_id => coords, :role => 0).delete_all
  User.where(:role => User::ROLES[:coordinator]).update_all(:role => User::ROLES[:user])
  User.where(:role => User::ROLES[:user]).limit(2).update_all(:role => User::ROLES[:coordinator])

  # need to make some author records for testing
  Author.destroy_all
  StoryAuthor.delete_all
  authors = []
  a = Author.create(id: 1)
  a.author_translations.create(locale: 'en', name: 'Demetria Guynes')
  a.author_translations.create(locale: 'ka', name: 'Demetria Guynes')
  authors << a
  a = Author.create(id: 2)
  a.author_translations.create(locale: 'en', name: 'Walter Willis')
  a.author_translations.create(locale: 'ka', name: 'Walter Willis')
  authors << a
  a = Author.create(id: 3)
  a.author_translations.create(locale: 'en', name: 'Allen Konigsberg')
  a.author_translations.create(locale: 'ka', name: 'Allen Konigsberg')
  authors << a
  a = Author.create(id: 4)
  a.author_translations.create(locale: 'en', name: 'Louis Szekely')
  a.author_translations.create(locale: 'ka', name: 'Louis Szekely')
  authors << a
  a = Author.create(id: 5)
  a.author_translations.create(locale: 'en', name: 'Joaquin Rafael Bottom')
  a.author_translations.create(locale: 'ka', name: 'Joaquin Rafael Bottom')
  authors << a
  a = Author.create(id: 6)
  a.author_translations.create(locale: 'en', name: 'Elizabeth Stamatina Fey')
  a.author_translations.create(locale: 'ka', name: 'Elizabeth Stamatina Fey')
  authors << a

  # now need to assign authors and story type to stories
  story_types = StoryType.select('id').map{|x| x.id}
  Story.all.each_with_index do |story, index|
    story.authors << authors.sample
    if index % 3 == 0
      story.authors << authors.sample
    end
    if index % 5 == 0
      story.authors << authors.sample
    end

    story.story_type_id = story_types.sample
    story.save
  end

  #####################
  ## Pages
  #####################
  puts "Loading Pages"
  Page.delete_all
  PageTranslation.delete_all
  p = Page.create(:id => 1, :name => 'about')
  p.page_translations.create(:locale => 'en', :title => 'About Us', content: "<p>The Chai Khana or &ldquo;tea house,&rdquo; is symbolic of a collective space where citizens come together and discuss socio-economic issues. It is a focal point for exchanging information and a flourishing place for social interaction and social entrepreneurship. Accordingly, Chai Khana seeks to attract new local and international attention to locally-led dialogue covering the region.</p>
  <p>At Chai Khana, we believe that open access to information, through issue-based multi-media content, could be a catalyst for positive change. We believe that if we invest in building up the skills of young journalists, they will create positive returns for themselves, their communities, and the region at large. The values of the NGO are therefore to build up a more open, ethnical and professional source of alternative media for the South Caucasus.</p>
  <h2>Mission Statement</h2>
  <p>The Mission of Chai Khana is to strengthen citizen engagement and Independent Journalism in the region. In doing so, Chai Khana seeks toencourage the diverse and thriving media landscape in the South Caucasus by helping to use innovative tools to improvethe quality and independence of objective reporting, and promote non-discrimination and tolerance between Armenians, Georgians and Azerbaijanis. Through this collaboration, the NGO seeks to expand the space for free expression and freedom of speech, including critical and alternative views in the South Caucasus.</p>
  <h2>What We Do</h2>
  <p>At Chai Khana, we draw on the talent of young journalists, film-makers, data analysts and photographers to publish an engaging, visually complex and dynamic multi-media series. We provide journalism trainings, mentorship and opportunities for collaboration in Tbilisi, Georgia.</p>
  <h2>Acknowledgements</h2>
  <p>Chai Khana would like to thank NIRAS who manages the fund provided by the Danish Foreign Ministry for their generous support and belief that we are making a difference.In addition, we would like to thank our partner, ForSet for their continued partnership and inspiration. And finally, we would like to thank all the journalists in this project who continue to share their time, skill, and energy to make the project possible.</p>
  <h2>Contact Information</h2>
  <p>chai.khana01@gmail.com</p>
  <h2>Vacancies</h2>
  <p>No current openings at this time</p>")
  p.page_translations.create(:locale => 'ka', :title => 'About Us', content: "<p>The Chai Khana or &ldquo;tea house,&rdquo; is symbolic of a collective space where citizens come together and discuss socio-economic issues. It is a focal point for exchanging information and a flourishing place for social interaction and social entrepreneurship. Accordingly, Chai Khana seeks to attract new local and international attention to locally-led dialogue covering the region.</p>
  <p>At Chai Khana, we believe that open access to information, through issue-based multi-media content, could be a catalyst for positive change. We believe that if we invest in building up the skills of young journalists, they will create positive returns for themselves, their communities, and the region at large. The values of the NGO are therefore to build up a more open, ethnical and professional source of alternative media for the South Caucasus.</p>
  <h2>Mission Statement</h2>
  <p>The Mission of Chai Khana is to strengthen citizen engagement and Independent Journalism in the region. In doing so, Chai Khana seeks toencourage the diverse and thriving media landscape in the South Caucasus by helping to use innovative tools to improvethe quality and independence of objective reporting, and promote non-discrimination and tolerance between Armenians, Georgians and Azerbaijanis. Through this collaboration, the NGO seeks to expand the space for free expression and freedom of speech, including critical and alternative views in the South Caucasus.</p>
  <h2>What We Do</h2>
  <p>At Chai Khana, we draw on the talent of young journalists, film-makers, data analysts and photographers to publish an engaging, visually complex and dynamic multi-media series. We provide journalism trainings, mentorship and opportunities for collaboration in Tbilisi, Georgia.</p>
  <h2>Acknowledgements</h2>
  <p>Chai Khana would like to thank NIRAS who manages the fund provided by the Danish Foreign Ministry for their generous support and belief that we are making a difference.In addition, we would like to thank our partner, ForSet for their continued partnership and inspiration. And finally, we would like to thank all the journalists in this project who continue to share their time, skill, and energy to make the project possible.</p>
  <h2>Contact Information</h2>
  <p>chai.khana01@gmail.com</p>
  <h2>Vacancies</h2>
  <p>No current openings at this time</p>")
  p.page_translations.create(:locale => 'az', :title => 'About Us', content: "<p>The Chai Khana or &ldquo;tea house,&rdquo; is symbolic of a collective space where citizens come together and discuss socio-economic issues. It is a focal point for exchanging information and a flourishing place for social interaction and social entrepreneurship. Accordingly, Chai Khana seeks to attract new local and international attention to locally-led dialogue covering the region.</p>
  <p>At Chai Khana, we believe that open access to information, through issue-based multi-media content, could be a catalyst for positive change. We believe that if we invest in building up the skills of young journalists, they will create positive returns for themselves, their communities, and the region at large. The values of the NGO are therefore to build up a more open, ethnical and professional source of alternative media for the South Caucasus.</p>
  <h2>Mission Statement</h2>
  <p>The Mission of Chai Khana is to strengthen citizen engagement and Independent Journalism in the region. In doing so, Chai Khana seeks toencourage the diverse and thriving media landscape in the South Caucasus by helping to use innovative tools to improvethe quality and independence of objective reporting, and promote non-discrimination and tolerance between Armenians, Georgians and Azerbaijanis. Through this collaboration, the NGO seeks to expand the space for free expression and freedom of speech, including critical and alternative views in the South Caucasus.</p>
  <h2>What We Do</h2>
  <p>At Chai Khana, we draw on the talent of young journalists, film-makers, data analysts and photographers to publish an engaging, visually complex and dynamic multi-media series. We provide journalism trainings, mentorship and opportunities for collaboration in Tbilisi, Georgia.</p>
  <h2>Acknowledgements</h2>
  <p>Chai Khana would like to thank NIRAS who manages the fund provided by the Danish Foreign Ministry for their generous support and belief that we are making a difference.In addition, we would like to thank our partner, ForSet for their continued partnership and inspiration. And finally, we would like to thank all the journalists in this project who continue to share their time, skill, and energy to make the project possible.</p>
  <h2>Contact Information</h2>
  <p>chai.khana01@gmail.com</p>
  <h2>Vacancies</h2>
  <p>No current openings at this time</p>")
  p.page_translations.create(:locale => 'ru', :title => 'About Us', content: "<p>The Chai Khana or &ldquo;tea house,&rdquo; is symbolic of a collective space where citizens come together and discuss socio-economic issues. It is a focal point for exchanging information and a flourishing place for social interaction and social entrepreneurship. Accordingly, Chai Khana seeks to attract new local and international attention to locally-led dialogue covering the region.</p>
  <p>At Chai Khana, we believe that open access to information, through issue-based multi-media content, could be a catalyst for positive change. We believe that if we invest in building up the skills of young journalists, they will create positive returns for themselves, their communities, and the region at large. The values of the NGO are therefore to build up a more open, ethnical and professional source of alternative media for the South Caucasus.</p>
  <h2>Mission Statement</h2>
  <p>The Mission of Chai Khana is to strengthen citizen engagement and Independent Journalism in the region. In doing so, Chai Khana seeks toencourage the diverse and thriving media landscape in the South Caucasus by helping to use innovative tools to improvethe quality and independence of objective reporting, and promote non-discrimination and tolerance between Armenians, Georgians and Azerbaijanis. Through this collaboration, the NGO seeks to expand the space for free expression and freedom of speech, including critical and alternative views in the South Caucasus.</p>
  <h2>What We Do</h2>
  <p>At Chai Khana, we draw on the talent of young journalists, film-makers, data analysts and photographers to publish an engaging, visually complex and dynamic multi-media series. We provide journalism trainings, mentorship and opportunities for collaboration in Tbilisi, Georgia.</p>
  <h2>Acknowledgements</h2>
  <p>Chai Khana would like to thank NIRAS who manages the fund provided by the Danish Foreign Ministry for their generous support and belief that we are making a difference.In addition, we would like to thank our partner, ForSet for their continued partnership and inspiration. And finally, we would like to thank all the journalists in this project who continue to share their time, skill, and energy to make the project possible.</p>
  <h2>Contact Information</h2>
  <p>chai.khana01@gmail.com</p>
  <h2>Vacancies</h2>
  <p>No current openings at this time</p>")
  p.page_translations.create(:locale => 'hy', :title => 'About Us', content: "<p>The Chai Khana or &ldquo;tea house,&rdquo; is symbolic of a collective space where citizens come together and discuss socio-economic issues. It is a focal point for exchanging information and a flourishing place for social interaction and social entrepreneurship. Accordingly, Chai Khana seeks to attract new local and international attention to locally-led dialogue covering the region.</p>
  <p>At Chai Khana, we believe that open access to information, through issue-based multi-media content, could be a catalyst for positive change. We believe that if we invest in building up the skills of young journalists, they will create positive returns for themselves, their communities, and the region at large. The values of the NGO are therefore to build up a more open, ethnical and professional source of alternative media for the South Caucasus.</p>
  <h2>Mission Statement</h2>
  <p>The Mission of Chai Khana is to strengthen citizen engagement and Independent Journalism in the region. In doing so, Chai Khana seeks toencourage the diverse and thriving media landscape in the South Caucasus by helping to use innovative tools to improvethe quality and independence of objective reporting, and promote non-discrimination and tolerance between Armenians, Georgians and Azerbaijanis. Through this collaboration, the NGO seeks to expand the space for free expression and freedom of speech, including critical and alternative views in the South Caucasus.</p>
  <h2>What We Do</h2>
  <p>At Chai Khana, we draw on the talent of young journalists, film-makers, data analysts and photographers to publish an engaging, visually complex and dynamic multi-media series. We provide journalism trainings, mentorship and opportunities for collaboration in Tbilisi, Georgia.</p>
  <h2>Acknowledgements</h2>
  <p>Chai Khana would like to thank NIRAS who manages the fund provided by the Danish Foreign Ministry for their generous support and belief that we are making a difference.In addition, we would like to thank our partner, ForSet for their continued partnership and inspiration. And finally, we would like to thank all the journalists in this project who continue to share their time, skill, and energy to make the project possible.</p>
  <h2>Contact Information</h2>
  <p>chai.khana01@gmail.com</p>
  <h2>Vacancies</h2>
  <p>No current openings at this time</p>")
end


=begin OLD STUFF FROM STORYBUILDER

#####################
## Pages
#####################
# puts "Loading Pages"
Page.delete_all
PageTranslation.delete_all
#p = Page.create(:id => 1, :name => 'about')
#p.page_translations.create(:locale => 'en', :title => 'About Story Builder')
#p.page_translations.create(:locale => 'ka', :title => 'Story Builder-ის შესახებ')
p = Page.create(:id => 2, :name => 'todo')
p.page_translations.create(:locale => 'en', :title => "Story Builder's To-Do List")
p.page_translations.create(:locale => 'ka', :title => 'Story Builder-ის გასაკეთებელი სია')

#####################
## Templates
#####################
puts 'loading templates'
Template.delete_all
Template.create(id:1,name:"nytimes",title:"NYTimes Template",description:"Taken from NY Times 'Game of Shark and Minow' story",author:"NY TIMES",default:true)
Template.create(id:2,name:"chca",title:"CHCA Template",description:"For CHCA specific story - not suggested for use in other stories",author:"Irakli Chumburidze",default:false,public:false)
Template.create(id:3,name:"chca_en",title:"CHCA Template(en)",description:"For CHCA specific story - not suggested for use in other stories",author:"Irakli Chumburidze",default:false,public:false)

#####################
## Languages
#####################
puts 'loading languages'
Language.delete_all
langs = [
  ["af", "Afrikaans"],
  ["sq", "shqipe"],
  ["ar", "العربية‏"],
  ["hy", "Հայերեն"],
  ["az", "Azərbaycan­ılı"],
  ["eu", "euskara"],
  ["be", "Беларускі"],
  ["bg", "български"],
  ["ca", "català"],
  ["hr", "hrvatski"],
  ["cs", "čeština"],
  ["da", "dansk"],
  ["div", "ދިވެހިބަސް‏"],
  ["nl", "Nederlands"],
  ["en", "English"],
  ["et", "eesti"],
  ["fo", "føroyskt"],
  ["fi", "suomi"],
  ["fr", "français"],
  ["gl", "galego"],
  ["ka", "ქართული"],
  ["de", "Deutsch"],
  ["el", "ελληνικά"],
  ["gu", "ગુજરાતી"],
  ["he", "עברית‏"],
  ["hi", "हिंदी"],
  ["hu", "magyar"],
  ["is", "íslenska"],
  ["id", "Bahasa Indonesia"],
  ["it", "italiano"],
  ["ja", "日本語"],
  ["kn", "ಕನ್ನಡ"],
  ["kk", "Қазащb"],
  ["sw", "Kiswahili"],
  ["kok", "कोंकणी"],
  ["ko", "한국어"],
  ["ky", "Кыргыз"],
  ["lv", "latviešu"],
  ["lt", "lietuvių"],
  ["mk", "македонски јазик"],
  ["ms", "Bahasa Malaysia"],
  ["mr", "मराठी"],
  ["mn", "Монгол хэл"],
  ["no", "norsk"],
  ["fa", "فارسى‏"],
  ["pl", "polski"],
  ["pt", "Português"],
  ["pa", "ਪੰਜਾਬੀ"],
  ["ro", "română"],
  ["ru", "русский"],
  ["sa", "संस्कृत"],
  ["sr", "srpski"],
  ["sk", "slovenčina"],
  ["sl", "slovenski"],
  ["es", "español"],
  ["sv", "svenska"],
  ["syr", "ܣܘܪܝܝܐ‏"],
  ["ta", "தமிழ்"],
  ["tt", "Татар"],
  ["te", "తెలుగు"],
  ["th", "ไทย"],
  ["tr", "Türkçe"],
  ["uk", "україньска"],
  ["ur", "اُردو‏"],
  ["uz", "U'zbek"],
  ["vi", "Tiếng Việt"],
  ["zh-TW", "繁體中文"],
  ["zh-CN", "简体中文"],
  ["am", "Հայերեն"]
]]

sql = "insert into languages (locale, name) values "
sql << langs.map{|x| "(\"#{x[0]}\", \"#{x[1]}\")"}.join(', ')
ActiveRecord::Base.connection.execute(sql)
# update count of languages with published stories
Language.update_counts

#####################
## Categories
#####################
puts "Loading Categories"
Category.delete_all
CategoryTranslation.delete_all
cat = Category.create(:id => 1)
cat.category_translations.create(:locale => 'ka', :name => 'კულტურა')
cat.category_translations.create(:locale => 'en', :name => 'Culture')
cat = Category.create(:id => 2)
cat.category_translations.create(:locale => 'ka', :name => 'თავდაცვა')
cat.category_translations.create(:locale => 'en', :name => 'Defence / Security')
cat = Category.create(:id => 3)
cat.category_translations.create(:locale => 'ka', :name => 'ეკონომიკა / ბიზნესი')
cat.category_translations.create(:locale => 'en', :name => 'Economy / Business')
cat = Category.create(:id => 4)
cat.category_translations.create(:locale => 'ka', :name => 'განათლება')
cat.category_translations.create(:locale => 'en', :name => 'Education')
cat = Category.create(:id => 5)
cat.category_translations.create(:locale => 'ka', :name => 'გარემო ')
cat.category_translations.create(:locale => 'en', :name => 'Environment')
cat = Category.create(:id => 6)
cat.category_translations.create(:locale => 'ka', :name => 'სამზარეულო')
cat.category_translations.create(:locale => 'en', :name => 'Food')
cat = Category.create(:id => 7)
cat.category_translations.create(:locale => 'ka', :name => 'გენდერი')
cat.category_translations.create(:locale => 'en', :name => 'Gender')
cat = Category.create(:id => 8)
cat.category_translations.create(:locale => 'ka', :name => 'ჯანმრთელობა')
cat.category_translations.create(:locale => 'en', :name => 'Health')
cat = Category.create(:id => 9)
cat.category_translations.create(:locale => 'ka', :name => 'ისტორია')
cat.category_translations.create(:locale => 'en', :name => 'History')
cat = Category.create(:id => 10)
cat.category_translations.create(:locale => 'ka', :name => 'როგორ')
cat.category_translations.create(:locale => 'en', :name => 'How To / DIY')
cat = Category.create(:id => 11)
cat.category_translations.create(:locale => 'ka', :name => 'იუმორი')
cat.category_translations.create(:locale => 'en', :name => 'Humor')
cat = Category.create(:id => 12)
cat.category_translations.create(:locale => 'ka', :name => 'მარლთმსაჯულება')
cat.category_translations.create(:locale => 'en', :name => 'Justice')
cat = Category.create(:id => 13)
cat.category_translations.create(:locale => 'ka', :name => 'ცხოვრების წესი')
cat.category_translations.create(:locale => 'en', :name => 'Lifestyle')
cat = Category.create(:id => 14)
cat.category_translations.create(:locale => 'ka', :name => 'პოლიტიკა')
cat.category_translations.create(:locale => 'en', :name => 'Politics')
cat = Category.create(:id => 15)
cat.category_translations.create(:locale => 'ka', :name => 'საზოგადოებრივი უსაფრთხოება')
cat.category_translations.create(:locale => 'en', :name => 'Public Saftey')
cat = Category.create(:id => 16)
cat.category_translations.create(:locale => 'ka', :name => 'მეცნიერება')
cat.category_translations.create(:locale => 'en', :name => 'Science')
# update count of categories with published stories
Category.update_counts

=end
