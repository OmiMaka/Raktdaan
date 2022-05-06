
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <title>RaktDaan</title>
  
  </head>
  <body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="index.php">RaktDaan</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="view.php">View</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="functions.php">Functions</a>
        </li>
        <li class="nav-item">
        <a class="nav-link" href="about.php">About</a>
        </li>
        
      </ul>
    </div>
  </div>
</nav>
 <br>
 <br>
</div>
<form method="POST">
<div class="container">
  <div class="row">
    <div class="col-sm">
    <button type="submit" name='persons'class="btn btn-primary" >Persons</button>
    </div>
    <div class="col-sm">
    <button type="submit" name='donors'class="btn btn-primary">Donors</button>
    </div>
    <div class="col-sm">
    <button type="submit" name='patients'class="btn btn-primary">Patients</button>
    </div>
    <div class="col-sm">
    <button type="submit" name='requests'class="btn btn-primary">Requests</button>
    </div>
    
  </div>
</div>
</form>

        
      


  
<br>
<br>

<?php
$server = "localhost";
$username = "root";
$password = "";


// Create connection
$con = mysqli_connect($server, $username, $password);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}
//echo "Success connecting to the db";
if(isset($_POST['persons'])){
$sql = "SELECT * FROM `raktdan`.`persons` ";
$result = $con->query($sql);



echo "<table class='table table-striped'>
<thead>
<tr class = 'table-danger'>

<th>Id</th>

<th>First Name</th>

<th>Last Name</th>

<th>Age</th>

</tr>
</thead>";

 

while($row = mysqli_fetch_array($result))

  {

  echo "<tr>";

  echo "<td>" . $row["pid"] . "</td>";

  echo "<td>" . $row['first_name'] . "</td>";

  echo "<td>" . $row['last_name'] . "</td>";

  echo "<td>" . $row['age'] . "</td>";

  echo "</tr>";

  }

echo "</table>";
}
else if(isset($_POST['donors'])){
  $sql = "SELECT * FROM `raktdan`.`donor` ";
  $result = $con->query($sql);
  
  
  
  echo "<table class='table table-striped'>
  <thead>
  <tr class = 'table-danger'>
  
  <th>Id</th>
  
  <th>Blood Type</th>
  
  <th>Weight (KG)</th>
  
  <th>Height (CM)</th>
  
  <th>Gender</th>

  <th>Next-Safe-Donation</th>
  
  </tr>
  </thead>";
  
   
  
  while($row = mysqli_fetch_array($result))
  
    {
  
    echo "<tr>";
  
    echo "<td>" . $row["pid"] . "</td>";
  
    echo "<td>" . $row['blood_type'] . "</td>";
  
    echo "<td>" . $row['weight'] . "</td>";
  
    echo "<td>" . $row['height'] . "</td>";

    echo "<td>" . $row['gender'] . "</td>";

    echo "<td>" . $row['nextSafeDonation'] . "</td>";
  
    echo "</tr>";
  
    }
  
  echo "</table>";
  }

  else if(isset($_POST['patients'])){
    $sql = "SELECT * FROM `raktdan`.`patient` ";
    $result = $con->query($sql);
    
    
    
    echo "<table class='table table-striped'>
    <thead>
    <tr class = 'table-danger'>
    
    <th>Id</th>
    
    <th>Blood Type</th>
    
    <th>Need Status</th>
    
    <th>Weight (KG)</th>
    
    </tr>
    </thead>";
    
     
    
    while($row = mysqli_fetch_array($result))
    
      {
    
      echo "<tr>";
    
      echo "<td>" . $row["pid"] . "</td>";
    
      echo "<td>" . $row['blood_type'] . "</td>";
    
      echo "<td>" . $row['need_status'] . "</td>";
  
      echo "<td>" . $row['weight'] . "</td>";
    
      echo "</tr>";
    
      }
    
    echo "</table>";
    }
    else if(isset($_POST['requests'])){
      $sql = "SELECT * FROM `raktdan`.`requests` ";
      $result = $con->query($sql);
      
      
      
      echo "<table class='table table-striped'>
      <thead>
      <tr class = 'table-danger'>
      
      <th>Request ID</th>
      
      <th>Location ID</th>
      
      <th>Blood Type Requested</th>
      
      <th>Date of Request</th>

      <th>Quantity Requested</th>

      
      </tr>
      </thead>";
      
       
      
      while($row = mysqli_fetch_array($result))
      
        {
      
        echo "<tr>";
      
        echo "<td>" . $row["rqid"] . "</td>";
      
        echo "<td>" . $row['lid'] . "</td>";
      
        echo "<td>" . $row['blood_type_requested'] . "</td>";
    
        echo "<td>" . $row['date_requested'] . "</td>";

        echo "<td>" . $row['quantity_requested_cc'] . "</td>";
      
        echo "</tr>";
      
        }
      
      echo "</table>";
      }
  
$con->close();
?>



   

    
    
    
    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    
    

    
  </body>
</html>