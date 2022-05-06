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
          <a class="nav-link" aria-current="page" href="view.php">View</a>
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
<form method="POST">
<div class="container-fluid">
<div class="row">
<div class="col">
<div class="card" style="width: 18rem;">
  <div class="card-body">
    <h5 class="card-title">Average Age of Donors</h5>
    <button type="submit" name='avg_age'class="btn btn-primary" >Average Donor Age</button>
    <br>
<?php

$server = "localhost";
$username = "root";
$password = "";
$db = "raktdan";

// Create connection
$con = mysqli_connect($server, $username, $password,$db);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}

if(isset($_POST['avg_age'])){
    $sql = "SELECT avg_age_donor() ";
    $result = mysqli_query($con,$sql);
    
    $row = mysqli_fetch_assoc($result);
    $ans = $row["avg_age_donor()"];
    echo "Average Age: ".$ans." years";
    
}
$con->close();
?>


  </div>
</div>
</div>
<div class="col">
<div class="card" style="width: 18rem;">
  <div class="card-body">
    <h5 class="card-title">Most Requested Blood Type</h5>
    <button type="submit" name='most_req'class="btn btn-primary" >Most Requested Blood Type</button>
    <br>
<?php

$server = "localhost";
$username = "root";
$password = "";
$db = "raktdan";

// Create connection
$con = mysqli_connect($server, $username, $password,$db);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}

if(isset($_POST['most_req'])){
    $sql = "SELECT most_requested_bloodType() ";
    $result = mysqli_query($con,$sql);
    
    $row = mysqli_fetch_assoc($result);
    $ans = $row["most_requested_bloodType()"];
    echo "Most Requested Blood Type: ".$ans;
    
}
$con->close();
?>
  </div>  
  </div>
  </div>
  <div class="col">
<div class="card" style="width: 18rem;">
  <div class="card-body">
    <h5 class="card-title">Donor Percentage by Gender </h5>
    <input type="text" class="form-control" name="gender" placeholder="Enter gender" >
    <br>
    <button type="submit" name='get_per'class="btn btn-primary" >Get Percentage</button>
    <br>
<?php

$server = "localhost";
$username = "root";
$password = "";
$db = "raktdan";

// Create connection
$con = mysqli_connect($server, $username, $password,$db);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}

if(isset($_POST['get_per'])){
    $gender = $_POST['gender'];
    $sql = "SELECT gender_percentage_of_donor('$gender') ";
    $result = mysqli_query($con,$sql);
    
    $row = mysqli_fetch_assoc($result);
    $ans = $row["gender_percentage_of_donor('$gender')"];
    echo "Percentage: ".$ans." %";
    
}
$con->close();
?>

  </div>
  </div>
  
</div>
<div class="col">
<div class="card" style="width: 18rem;">
  <div class="card-body">
    <h5 class="card-title">Percentage of global Inventory</h5>
    <input type="text" class="form-control" name="b_t" placeholder="Enter required blood type" >
    <br>
    <button type="submit" name='get_per2'class="btn btn-primary" >Get Percentage</button>
    <br>
<?php

$server = "localhost";
$username = "root";
$password = "";
$db = "raktdan";

// Create connection
$con = mysqli_connect($server, $username, $password,$db);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}

if(isset($_POST['get_per2'])){
    $b_t = $_POST['b_t'];
    $sql = "SELECT requested_blood_type_global_percentage('$b_t'); ";
    $result = mysqli_query($con,$sql);
    
    $row = mysqli_fetch_assoc($result);
    $ans = $row["requested_blood_type_global_percentage('$b_t')"];
    echo "Percentage of ".$b_t." : ".$ans." %";
    
}
$con->close();
?>


  </div>
</div>
</div>
<div class="col">
<div class="card" style="width: 18rem;">
  <div class="card-body">
    <h5 class="card-title">Validate Donor</h5>
    <input type="text" class="form-control" name="peid" placeholder="Enter pre-examination id" >
    <br>
    <input type="text" class="form-control" name="gender" placeholder="Enter gender" >
    <br>
    <button type="submit" name='validate'class="btn btn-primary" >Validate</button>
    <br>
<?php

$server = "localhost";
$username = "root";
$password = "";
$db = "raktdan";

// Create connection
$con = mysqli_connect($server, $username, $password,$db);
// Check connection
if(!$con){
    die("connection to this database failed due to" . mysqli_connect_error());
}

if(isset($_POST['validate'])){
    $gender = $_POST['gender'];
    $peid = $_POST['peid'];
    $sql = "SELECT validate_donation('$peid',$gender'); ";
    $result = mysqli_query($con,$sql);
    
    //$row = mysqli_fetch_assoc($result);
    $ans = $result["validate_donation('$peid',$gender')"];
    echo $ans;
    if ($ans == "1"){
        $val = 'Can Donate';
    }
    else{
        $val = 'Cannot Donate';
    }
    echo $val;

    
}
$con->close();
?>

  </div>
  </div>
  
</div>
<div class="col">
</div>
</div>
</form>


  <!-- Option 1: Bootstrap Bundle with Popper -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    
    

    
</body>
</html>