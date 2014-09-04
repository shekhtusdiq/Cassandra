class cassandra::params {
#Install Dir
  $install_dir = $::hostname ? {
  	default => "/home/cassandra"
  }

#Cassandra Home
  $cassandra_home = $::hostname ? {
	default => "/home/cassandra/apache-cassandra-2.0.9"
  }

#Cassandra bin
  $cassandra_bin = $::hostname ? {
        default => "${cassandra::params::cassandra_home}/bin"
  }

#Cassandra conf
  $cassandra_conf = $::hostname ? {
        default => "${cassandra::params::cassandra_home}/conf"
  }

#Download Url
  $get_url = $::hostname ? {
	default => "https://archive.apache.org/dist/cassandra/2.0.9/apache-cassandra-2.0.9-bin.tar.gz"	
  }

#Cluster name
  $cluster_name = $::hostname ? {
     	default => "Pramti",
  }

#Cassandra nodes        
  $seeds = $::hostname ? {
    	default => "slaveA, slaveB",
  }
}
