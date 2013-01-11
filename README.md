# ChinaRegion

ChinaRegion Provide The Regions Of China. Support Language Ruby on Rails.
       

## How to use it [Usage]

Put 'gem china_region' to your Gemfile:

gem 'china_region', :git => 'git://github.com/encoreshao/china_region.git'. 

Run bundler command to install the gem:

    bundle install

After you install the gem, you need run the generator:

    rails g china_region:install
   
   It will:
   * Generate `db/migrate/<timestamp>create_china_region_tables.rb` migrate file to your app, `provinces`, `cities`, `districts` table is used for store the regions.
   * Copy cities.yml to config/ directory.
   * Run `rake db:migrate`.
   * Run `rake china_region:import`.

   Now you have there ActiveRecord modules: `Province`, `City`, `District`.
   
   Run with `rails g` for get generator list.

If you want to customize the region modules you can run the generator:

    rails g china_region:model

   This will create:
   
    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   So you can do what you want to do in this files.
   

#### Model

    a = Province.all.sample
    a.name
    a.cities.map(&:name)
    
    a.districts.map(&:name)
    
    c = City.last
    c.name
    c.zip_code
    c.name_en
    c.name_abbr
    c.districts.map(&:name)
    c.siblings.map(&:name)
    
#### View

    <%= form_for(@post) do |f| %>
      <div class="field">
        <%= f.label :province, '选择地区：' %><br />
        
        # FormBuilder
        # <%= f.region_select :city %>
        # <%= f.region_select [:province, :city, :district] %>
        # <%= f.region_select [:province, :city] %>
        # <%= f.region_select [:city, :district] %>
        # <%= f.region_select [:province, :district] %>
        
        # FormHelper
        # <%= region_select :post, :province %>
        # <%= region_select :post, [:province, :city, :district] %>
        # ...
        
      </div>
    <% end %>

##### prompt
  
You need define `province_select_prompt`, `city_select_prompt`, `district_select_prompt` helpers for each select prompt.
If you have not define these helpers, it will use the default one like:
    
    def region_prompt(region_klass)
      human_name = region_klass.model_name.human
      "请选择#{human_name}"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

ChinaRegion is released under the MIT license.

