class cassandra::params {
#Install Dir
  $install_dir = $::hostname ? {
  	default => "/home/cassandra"
  }

#Cassandra Home
  $cassandra_home = $::hostname ? {
	default => "/home/cassandra/apache-cassandra-2.0.10"
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
	default => "http://apache.mirrors.tds.net/cassandra/2.0.10/apache-cassandra-2.0.10-bin.tar.gz"	
  }

# JRE Home
  $jre_home = $::hostname ? {
	default => "${cassandra::params::cassandra_home}/jre1.7.0_55"
 }


#Cluster name
  $cluster_name = $::hostname ? {
     	default => "Pramti",
  }

#Cassandra nodes        
  $seeds = $::hostname ? {
    	default => "192.168.56.103, 192.168.56.104",
  }
}
