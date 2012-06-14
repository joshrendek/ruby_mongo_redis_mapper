# Installation

```
bundle install 
```

# Loading your data into MongoDB 

You can look at the ```load_dot.rb``` file to see how to load your files into MongoDB. A simple base class is defined in ```dot_mongoid.rb```.

This part of the process splits the file and inserts it into MongoDB based on the key you want to search on. The Mongo record format is [key, actual_line_from_file] this way when you search for the key, all you need to do is spit the line into an output file to use later. Make sure you add the index on your key that your using otherwise performance will be suboptimal. 

# Usage

Open up ```qdata.rb```, there are two classes in here called FileSearcher and ResqueSearcher. You can add others if you need a different method of searching. The FileSearcher is old and shouldn't be used as it was using an in memory hash to check the files and was horribly slow. The main class is ResqueSearcher. 

## ResqueSearcher 
For an example of how to use the ResqueSearcher check out ```dot_work_items.rb```. It starts by opening up a file that contains all the keys we want to grab from the data. It then slices them into groups of 8, sends it to the Resque queue using the ResqueSearcher, the array of keys to search for, whether or not to use a split search, and the column to check on when splitting. 

## Starting the search process

* Start Redis ```redis-server```
* Start resque-web ```resque-web```
* Start MongoDB ```mongod``` 
* Start the workers ```VERBOSE=1 COUNT=6 QUEUE=* RAILS_ENV=production rake resque:workers --trace```

Sit back and watch resque-web to see the workers die down.

A good way to pound through a ton of data quickly is to spin up some EC2 instances to connect to the master and you can have hundreds of workers going at once with no issues. Once your finished you can just combine the .out files and do what you need to do with them.


