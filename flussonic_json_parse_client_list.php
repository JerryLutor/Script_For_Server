<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Flussonic clients v0.2</title>

    <link rel="stylesheet" href="//stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<style>
td, th { border: 1px solid #111; padding: 6px; }
th { font-weight: 700; }
</style>

  </head>

<script>
var index;      // cell index
var toggleBool; // sorting asc, desc 
function sorting(tbody, index){
    this.index = index;
    if(toggleBool){
        toggleBool = false;
    }else{
        toggleBool = true;
    }

    var datas= new Array();
    var tbodyLength = tbody.rows.length;
    for(var i=0; i<tbodyLength; i++){
        datas[i] = tbody.rows[i];
    }

    // sort by cell[index] 
    datas.sort(compareCells);
    for(var i=0; i<tbody.rows.length; i++){
        // rearrange table rows by sorted rows
        tbody.appendChild(datas[i]);
    }   
}

function compareCells(a,b) {
    var aVal = a.cells[index].innerText;
    var bVal = b.cells[index].innerText;

    aVal = aVal.replace(/\,/g, '');
    bVal = bVal.replace(/\,/g, '');

    if(toggleBool){
        var temp = aVal;
        aVal = bVal;
        bVal = temp;
    } 

    if(aVal.match(/^[0-9]+$/) && bVal.match(/^[0-9]+$/)){
        return parseFloat(aVal) - parseFloat(bVal);
    }
    else{
          if (aVal < bVal){
              return -1; 
          }else if (aVal > bVal){
                return 1; 
          }else{
              return 0;       
          }         
    }
}
</script>

  <body>

      <header>

      </header>

      <section>

</section>

<?php


function array_sort($array, $on, $order=SORT_ASC)
{
    $new_array = array();
    $sortable_array = array();

    if (count($array) > 0) {
        foreach ($array as $k => $v) {
            if (is_array($v)) {
                foreach ($v as $k2 => $v2) {
                    if ($k2 == $on) {
                        $sortable_array[$k] = $v2;
                    }
                }
            } else {
                $sortable_array[$k] = $v;
            }
        }

        switch ($order) {
            case SORT_ASC:
                asort($sortable_array);
            break;
            case SORT_DESC:
                arsort($sortable_array);
            break;
        }

        foreach ($sortable_array as $k => $v) {
            $new_array[$k] = $array[$k];
        }
    }

    return $new_array;
}


$response=file_get_contents("http://login:pass@serverip:8080/flussonic/api/sessions");
#$data =  json_decode($response);


$array = json_decode($response, true);
$resultArray = isset($array['sessions']) ? $array['sessions'] : [];

asort($resultArray);
$keys = array_keys($resultArray);

$resultArray1 = (array_sort($resultArray, 'type', SORT_DESC));


echo '<table summary="Pioneer" class="table table-striped table-dark">';
echo '  <thead>';
echo '    <tr>';
echo '      <th scope="col"  onclick="sorting(tbody01, 0)">IP</th>';
echo '      <th scope="col"  onclick="sorting(tbody01, 1)">Страна</th>';
echo '      <th scope="col"  onclick="sorting(tbody01, 2)">Канал</th>';
echo '      <th scope="col"  onclick="sorting(tbody01, 3)">Тип потока</th>';
echo '      <th scope="col"  onclick="sorting(tbody01, 4)">User Agent</th>';
echo '    </tr>';
echo '  </thead>';
echo '  <tbody id="tbody01">';
foreach($resultArray1 as $result){
        echo '<tr>';
        echo '<td>'.(isset($result['ip']) ? $result['ip'] : '-') .'</td>';
        echo '<td>'.(isset($result['country']) ? $result['country'] : '-') .'</td>';
        echo '<td>'.(isset($result['name']) ? $result['name'] : '-') .'</td>';
	echo '<td>'.(isset($result['type']) ? $result['type'] : '-') .'</td>';
	echo '<td>'.(isset($result['user_agent']) ? $result['user_agent'] : '-') .'</td>';

        #echo '<td>'.(isset($result['attributes']['name']) ? $result['attributes']['name'] : '-').'</td>';
        #echo '<td>'.(isset($result['attributes']['description']) ? $result['attributes']['description'] : '-').'</td>';
        #echo '<td>'.(isset($result['attributes']['funded_year']) ? $result['attributes']['funded_year'] : '-').'</td>';
        echo '</tr>';
}

echo '  </tbody>';
echo '</table>';

#print_r($resultArray1);

?>

</body>
</html>