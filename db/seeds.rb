# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# run-time variables (set these to true if you want seeds to run them):
# 1. load_story_types
# 2. delete_story_types
# 3. load_languages
# 4. delete_languages
# 5. load_test_data
# 6. delete_test_data
# 7. load_categories
# 8. delete_categories
#
# To load seeds with all variables set to true:
#
# bundle exec rake db:seed load_story_types=true delete_story_types=true load_languages=true delete_languages=true load_test_data=true delete_test_data=true load_categories=true delete_categories=true
################################
#------------------------------- StoryType

  if ENV['delete_story_types'].present? || ENV['load_story_types'].present?
    puts "deleting data in database (StoryType, StoryTypeTranslation)"
    StoryType.delete_all
    StoryTypeTranslation.delete_all
  end

  if ENV['load_story_types'].present?
    puts "loading data in database (StoryType, StoryTypeTranslation)"
    t = StoryType.create(:id => 1, :sort_order => 3)
    t.story_type_translations.create(:locale => 'ka', :name => 'Story')
    t.story_type_translations.create(:locale => 'en', :name => 'Story')
    t = StoryType.create(:id => 2, :sort_order => 4)
    t.story_type_translations.create(:locale => 'ka', :name => 'Talk Show')
    t.story_type_translations.create(:locale => 'en', :name => 'Talk Show')
    t = StoryType.create(:id => 3, :sort_order => 2)
    t.story_type_translations.create(:locale => 'ka', :name => 'Video')
    t.story_type_translations.create(:locale => 'en', :name => 'Video')
    t = StoryType.create(:id => 4, :sort_order => 1)
    t.story_type_translations.create(:locale => 'ka', :name => 'Photo')
    t.story_type_translations.create(:locale => 'en', :name => 'Photo')
    t = StoryType.create(:id => 5, :sort_order => 5)
    t.story_type_translations.create(:locale => 'ka', :name => 'Infographic')
    t.story_type_translations.create(:locale => 'en', :name => 'Infographic')
  end

#------------------------------- Language

  if ENV['delete_languages'].present? || ENV['load_languages'].present?
    puts "deleting data in database (StoryType, StoryTypeTranslation)"
    Language.delete_all
  end

  if ENV['load_story_types'].present?
    puts "loading data in database (Language)"

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
  end

#------------------------------- Categories

  if ENV['delete_categories'].present? || ENV['load_categories'].present?
    puts "deleting data in database (Category, CategoryTranslation)"
    Category.delete_all
    CategoryTranslation.delete_all
  end

  if ENV['load_categories'].present?
    puts "loading data in database (Category, CategoryTranslation)"

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
  end

#------------------------------- Test Data

  if ENV['delete_test_data'].present? || ENV['load_test_data'].present?
    puts "deleting data in database (Theme, ThemeTranslation, StoryTheme, Page, PageTranslation, Author, StoryAuthor)"
    Theme.delete_all
    ThemeTranslation.delete_all
    StoryTheme.delete_all
    Page.delete_all
    PageTranslation.delete_all
    Author.destroy_all
    StoryAuthor.delete_all
  end

  if ENV['load_test_data'].present?
    puts "loading data in database (Theme, ThemeTranslation, StoryTheme, Page, PageTranslation, Author, StoryAuthor)"

    if !Rails.env.production?

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
    end
  end

#------------------------------- Not Used

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

=end
