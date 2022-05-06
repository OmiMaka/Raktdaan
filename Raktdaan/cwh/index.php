



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
    <a class="navbar-brand" href="#">RaktDaan</a>
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
<?php
$insert = false;
if(isset($_POST['persons'])){
    // Set connection variables
    $server = "localhost";
    $username = "root";
    $password = "";

    // Create a database connection
    $con = mysqli_connect($server, $username, $password);

    // Check for connection success
    if(!$con){
        die("connection to this database failed due to" . mysqli_connect_error());
    }
    //echo "Success connecting to the db";

    $pid = $_POST['pid'];
    $first = $_POST['first'] ;
    $last = $_POST['last'];
    $age = $_POST['age'];


    $sql = "INSERT INTO `raktdan`.`persons` (`pid`, `first_name`, `last_name`, `age`) VALUES ('$pid', '$first', '$last', '$age');";

    if($con->query($sql) == true){
        // echo "Successfully inserted";

        // Flag for successful insertion
        $insert = true;
    }
    else{
        echo "ERROR: $sql <br> $con->error";
    }
    $con->close();
}
?>
  <div class="container">
  <form method="POST" action="index.php">
    <h2>Persons Table</h2>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="pid">P_ID</label>
          <input type="text" class="form-control" name="pid" placeholder="ID" id="ID">
        </div>
      </div>
      <div class="col-md-6">

        <div class="form-group">
          <label for="age">Age</label>
          <input type="number" class="form-control" name="age" id="age" placeholder="Age">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="first">First Name</label>
          <input type="text" class="form-control" name="first" placeholder="First Name" id="first">
        </div>
      </div>
      <!--  col-md-6   -->

      <div class="col-md-6">
        <div class="form-group">
          <label for="last">Last Name</label>
          <input type="text" class="form-control" name="last" placeholder="Last Name" id="last">
        </div>
      </div>
      <!--  col-md-6   -->
    </div>

    <!--  row   -->
<br>
    <div class="row">
    <div class="col-md-6">
        <div class="form-group">
        <label for="last"></label>
        <button type="submit" name="persons" class="btn btn-primary">Submit</button>
        </div>
        </div>
        </div>
    
  </form>
  
</div>

<?php
$insert = false;
if(isset($_POST['donor'])){
    // Set connection variables
    $server = "localhost";
    $username = "root";
    $password = "";

    // Create a database connection
    $con = mysqli_connect($server, $username, $password);

    // Check for connection success
    if(!$con){
        die("connection to this database failed due to" . mysqli_connect_error());
    }
    //echo "Success connecting to the db";

    $pid = $_POST['pid'];
    $b_t = $_POST['blood_type'] ;
    $weight = $_POST['weight'];
    $height = $_POST['height'];
    $gender = $_POST['gender'];
    $NSD = $_POST['NSD'];


    $sql = "INSERT INTO `raktdan`.`donor` (`pid`, `blood_type`, `weight`, `height`, `gender`, `nextSafeDonation`) VALUES ('$pid', '$b_t', '$weight', '$height','$gender','$NSD');";

    if($con->query($sql) == true){
        // echo "Successfully inserted";

        // Flag for successful insertion
        $insert = true;
    }
    else{
        echo "ERROR: $sql <br> $con->error";
    }
    $con->close();
}
?>

<br>
<br>

<div class="container">
  <form method="POST" action="index.php">
    <h2>Donor Table</h2>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="pid">P_ID</label>
          <input type="text" class="form-control" name="pid" placeholder="ID" id="ID">
        </div>
      </div>
      <div class="col-md-6">

        <div class="form-group">
          <label for="age">Blood Type</label>
          <input type="text" class="form-control" name="blood_type" id="blood_type" placeholder="Blood Type">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="first">Weight KG</label>
          <input type="number" class="form-control" name="weight" placeholder="Weight" id="weight">
        </div>
      </div>
      <!--  col-md-6   -->

      <div class="col-md-6">
        <div class="form-group">
          <label for="last">Height CM</label>
          <input type="number" class="form-control" name="height" placeholder="height" id="height">
        </div>
      </div>
      <!--  col-md-6   -->
    </div>
    
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="first">Gender</label>
          <input type="text" class="form-control" name="gender" placeholder="Gender" id="gender">
        </div>
      </div>
      <!--  col-md-6   -->

      <div class="col-md-6">
        <div class="form-group">
          <label for="last">Next Safe Donation</label>
          <input type="date" class="form-control" name="NSD" placeholder="NSD" id="NSD">
        </div>
      </div>
      <!--  col-md-6   -->
    </div>
    <!--  row   -->
    <br>
    <div class="row">
    <div class="col-md-6">
        <div class="form-group">
        <label for="last"></label>
        <button type="submit" class="btn btn-primary" name="donor">Submit</button>
        </div>
        </div>
        </div>
    
  </form>
  
</div>

<?php
$insert = false;
if(isset($_POST['donation'])){
    // Set connection variables
    $server = "localhost";
    $username = "root";
    $password = "";

    // Create a database connection
    $con = mysqli_connect($server, $username, $password);

    // Check for connection success
    if(!$con){
        die("connection to this database failed due to" . mysqli_connect_error());
    }
    //echo "Success connecting to the db";

    $did = $_POST['did'];
    $pid = $_POST['pid'];
    $d_t = $_POST['d_t'] ;
    $peid = $_POST['peid'];
    $nurse = $_POST['nurse'];
    $amount = $_POST['amount_cc'];


    $sql = "INSERT INTO `raktdan`.`donation` (`did`, `pid`, `peid`, `nurse`, `amount_donated_CC`, `donation_type`) VALUES ('$did', '$pid', '$peid', '$nurse','$amount','$d_t');";

    if($con->query($sql) == true){
        // echo "Successfully inserted";

        // Flag for successful insertion
        $insert = true;
    }
    else{
        echo "ERROR: $sql <br> $con->error";
    }
    $con->close();
}
?>

<br> 
<br>
<div class="container">
  <form method="POST" action="index.php">
    <h2>Donation Table</h2>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="did">D_ID</label>
          <input type="text" class="form-control" name="did" placeholder="Donation ID" id="DID">
        </div>
      </div>
      <div class="col-md-6">

        <div class="form-group">
          <label for="pid">ID</label>
          <input type="text" class="form-control" name="pid" id="pid" placeholder="ID">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="donation_type">Donation Type</label>
          <input type="text" class="form-control" name="d_t" placeholder="Donation Type" id="donation_type">
        </div>
      </div>
      <!--  col-md-6   -->

      <div class="col-md-6">
        <div class="form-group">
          <label for="last">Pre-Exam ID</label>
          <input type="text" class="form-control" name="peid" placeholder="Peid" id="peid">
        </div>
      </div>
      <!--  col-md-6   -->
    </div>
    
    <div class="row">
      <div class="col-md-6">
        <div class="form-group">
          <label for="first">Nurse</label>
          <input type="text" class="form-control" name="nurse" placeholder="Nurse ID" id="nurse_id">
        </div>
      </div>
      <!--  col-md-6   -->

      <div class="col-md-6">
        <div class="form-group">
          <label for="Amount_cc">Amount Donated</label>
          <input type="number" class="form-control" name="amount_cc" placeholder="Amount" id="amount_cc">
        </div>
      </div>
      <!--  col-md-6   -->
    </div>
    <!--  row   -->
    <br>
    <div class="row">
    <div class="col-md-6">
        <div class="form-group">
        <label for="last"></label>
        <button type="submit" class="btn btn-primary" name="donation">Submit</button>
        </div>
        </div>
        </div>
    
  </form>
  
</div>



   

    
    
    
    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    
    

    
  </body>
</html>