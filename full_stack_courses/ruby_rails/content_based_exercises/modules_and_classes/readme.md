This project will reinforce the Odin Project chapters surrounding
modules and classes. This is my own recounting of the content after
several months. Because this is for notes and learning, I am ignoring
the convention of making the class / module file name match the content.

---

first start with main_class.rb. This will be the basic class item
that all other classes are going to extend from. As borrowing from
the content of the chapters, we will make this class in reference
to all mammals. 

Because this is the base class for all our mammal subclasses,
this will have the base methods that all mammals will have.
Writing in this fashion allows us to group similar functionality, 
encourage DRY code, and allow us to build subclasses and 
modules better. 

---

next we will look at a subclass. continuing with our example, this will take our mammal class and add additional functionality 
specific to the subclass... or in our case, we will create a sublcass of dog and it will have special methods ontop of the mammal ones.

Each subclass can have its own organization of shared methods through modules. 

---

There are modules that give our classes certain functionality... in this case actions like climbing and swimming. 
These modules can be mixed into any class that needs them. For Humans, they can swim and climb so they have both included in the
class definition. Monekys can only climb (in this example) so they will only include the climbing module. 

I have created a umb module for gender traits - this shows one way to organize a bunch of methods using submodules. It's probably
not a pattern that will come up often, but i find it useful for select circumstances. In this case, all of our mammal 
subclasses will have genders, and each instance of a mammal can use these methods. Therefore, I included this module 
at the superclass of Mammal.


