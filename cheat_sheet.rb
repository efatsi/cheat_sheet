######################################

ROOT REDIRECT

ga, gc 'app initialized', git rm public/index.html

in config/routes.rb

  match 'home' => 'home#home', :as => :home
	# Change root path
	root :to => 'home#home'
	
rake routes

import home folder and home_controller.rb

######################################

BOOTSTRAP

rails generate bootstrap:install
copy bootstrap_and_overrides code in

######################################

ARBEIT BAR

import maroon.png into app/assets/images

<body>
	<%= link_to(image_tag('maroon.png'), home_path) %>
	<div id="wrapper">
		<!-- NAV BAR -->
		<div class="navbar">
		  <div class="navbar-inner">
		    <div class="container">
		      <a class="btn btn-navbar" data-toggle="collapse" data-target=".collapse">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </a>
		      <div class="nav-collapse">
		        <ul class="nav">
		          <li><%= link_to "Home", home_path %></li>
		        </ul>	
		        
						<% if logged_in? %>
							<p class="ident pull-right">
								Welcome, <%= link_to current_user.proper_name, user_path(current_user) %> | 
								<%= link_to "Logout", logout_path %>
							</p>
						<% else %>
							<%= link_to 'Login', login_path %>
						<% end %>
								        					
		      </div>
		    </div>
		  </div>
		</div>

		<!-- MAIN CONTENT -->
		<div class="container">
			<!-- flash messages -->
			<% flash.each do |name, msg| %>
				<div class="alert alert-<%= name == :notice ? "success" : "error" %>">
					<a class="close" data-dismiss="alert">&times;</a>
					<%= msg %>
				</div>
	    <% end %>
			<div class="row">
				<!-- main content placed here -->
				<div class="span12">
					<%= yield %>
				</div>
			</div>
		</div>
	</div>
</body>

######################################

CREAMERY NAV BAR

in views/layouts/application.html.erb

<!-- NAV BAR HERE -->
	<div class="navbar navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
			  <a class="btn btn-navbar" data-toggle="collapse" data-target=".collapse">
			    <span class="icon-bar"></span>
			    <span class="icon-bar"></span>
			    <span class="icon-bar"></span>
			  </a>
			  <a class="brand">HOME</a>
			  <div class="nav-collapse">
			    <ul class="nav">
		      	<li><%= link_to "Home", home_path %></li>
			    </ul>
			  </div>
			</div>
		</div>
	</div>

	<!-- MAIN CONTENT -->
	<div class="container">
		<!-- flash messages -->
		<% flash.each do |name, msg| %>
			<div class="alert alert-<%= name == :notice ? "success" : "error" %>">
				<a class="close" data-dismiss="alert">&times;</a>
				<%= msg %>
			</div>
    <% end %>
		<div class="row">
			<!-- main content placed here -->
			<div class="span12">
				<%= yield %>
			</div>
		</div>
	</div>
	
######################################

FLASH NOTICES

in views/layouts/application.html.erb
    <% flash.each do |name, msg| %>
      <%= content_tag :div, msg, :id => "flash_#{name}" %>
    <% end %>
    
OR PROBABLY

		<% flash.each do |name, msg| %>
			<div class="alert alert-<%= name == :notice ? "success" : "error" %>">
				<a class="close" data-dismiss="alert">&times;</a>
				<%= msg %>
			</div>
    <% end %>

    
WITH FADE

in app/assets/javascripts/application.js
// Flash fade
	$(function() {
	   $('.alert-success').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});
	
	$(function() {
	   $('.alert-error').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});
    

######################################

PAGINATE

in controller
	@products = Product.paginate(:page => params[:page], :per_page => 10)

in view
	<%= will_paginate @products %>


######################################

PAGINATE & SEARCH

in model
	def self.search(search, page)
  	paginate :per_page => 8, :page => page, :conditions => ['first_name || last_name like ?', "%#{search}%"], :order => 'last_name, first_name'
	end

in controller	
	def index
		@products = Product.search(params[:search], params[:page])
	end

in view
	<%= form_tag products_path, :method => 'get' do %>
		<p>
			<%= text_field_tag :search, params[:search] %>
			<%= submit_tag "Search", :name => nil %>
		</p>
	<% end %>
	
	<%= will_paginate @products %>


######################################

AUTHENTICATION

rgm user first_name:string last_name:string email:string role:string password_digest:string OTHER_id:integer
rdm

in models/user.rb
has_secure_password
attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :role, :OTHER_id

  def proper_name
    "#{first_name} #{last_name}"
  end
	
	def self.authenticate(email, password)
		find_by_email(email).try(:authenticate, password)
	end
		
	def self.find_by_email(email)
		where(:email => email).first
	end
	
  ROLES = [['Employee', 'employee'],['Manager', 'manager'],['Administrator', 'admin']]
	
in controllers/application_controller.rb
  private
  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
  	current_user
  end
  helper_method :logged_in?
  
  def check_login
  	redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end
  helper_method :check_login
  
  ### Only to be used with CanCan ###
#  rescue_from CanCan::AccessDenied do |exception|
#  	flash[:error] = "You cannot go here. Since you are not authorized. This is a haiku."
#  	redirect_to root_url
#  end
  
in any controllers you want
  before_filter :check_login, :except => [:index, :show]

import sessions_controller.rb
import user_controller.rb
import users folder (views)
# Update _form.html.erb with OTHER value
import sessions folder (views)

add the following routes to config/routes.rb
	resources :users
	resources :sessions
	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login

#### can add the arbeit nav bar login code back in ####


######################################

CANCAN

import ability.rb

in models/user.rb
	def role?(authorized_role)
		return false if role.nil?
		role.to_sym == authorized_role
	end
	
to controllers
	load_and_authorize_resource
	
uncomment CanCan rescue method in controllers/application_controller.rb


######################################

MAPS

# need this, then can define the map function
  before_save :find_object_coordinates
  
	def find_object_coordinates
		coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{street}, #{zip}"
		if coord.success
			self.latitude, self.longitude = coord.ll.split(',')
		end
	end
	
# map functions	
  def create_map_link(zoom = 16, width = 300, height = 300)
 		marker = "&markers=color:red%7Ccolor:red%7C#{latitude},#{longitude}"		
 		map = "http://maps.google.com/maps/api/staticmap?center=#{latitude},#{longitude}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{marker}&sensor=false"
	end  
	
	def Object.create_all_map_link(zoom = 13, width = 600, height = 600)
		markers = ""; 
		i = 1
		total_lat = 0; total_lon = 0;
		Object.alphabetical.each do |object|
			markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{object.latitude},#{object.longitude}"
			i += 1
			total_lat += store.latitude.to_f
			total_lon += store.longitude.to_f
		end
		lat = total_lat/Object.all.length
		lon = total_lon/Object.all.length
		map = "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
	end
	
# and in the views
	<div class="span5">
		<div class="well">
		<% if Object.all.length != 0 %>
			</br>
			<%= image_tag Object.create_all_map_link %>
		<% end %>
		</div>
	</div>
	
# OR
	<%= image_tag @store.create_map_link %>

######################################

NESTED FORMS

# In application.js
//= require jquery_nested_form

# In elder model
	has_many :youngers
	, :youngers_attributes ### to attr_accessible
  accepts_nested_attributes_for :youngers, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

# In younger model
	belongs_to :elder
	
# In elder controller
  def new
    @elder = Elder.new
   	2.times do
    	@elder.youngers.build
		end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @elder }
    end
  end
  
### SEE NESTED FORMS FOLDER FOR VIEW FILES ###


######################################

POLYMORPHISMS

rgs Comment content:text name:string email:string

# In elders' models
  has_many :comments, :as => :commentable
  
# In younger(comments) model
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy

# In younger migration
      t.references :commentable, :polymorphic => true
      
## Will need a controller for the polymorphic attribute, and partials for elder#show

# In elders' controllers 
  def show
    @object = Object.find(params[:id])
    
    @comments = @object.comments
    @commentable = @object
  end
  
# In config/routes.rb

  resources :elder1 do
    resources :comments
  end
  resources :elder2 do
    resources :comments
  end
      
######################################

CREATEME

rg migration createME

  def up
  	admin = User.new
  	admin.first_name = "Eli"
  	admin.last_name = "Fatsi"
  	admin.email = "elias@example.com"
  	admin.password = "secret"
  	admin.password_confirmation = "secret"
  	admin.role = "admin"
  	admin.save!
  end

  def down
  	admin = User.find_by_email "elias@example.com"
  	User.delete admin
  end
end


######################################

CUCUMBER TESTS

bundle exec cucumber
