<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="http://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/leaflet/1.8.0/leaflet.css" integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
      
        <title>Coffee Shop - Map </title>
        <style>
        body {
            padding: 0;
            margin: 0;
        }
        html, body, #map {
            height: 100%;
            width: 100%;
        }
        .addBtnClass {
            position:fixed;
            bottom: 1.5rem;
            right: 1.5rem;
            z-index: 999999;
        }
        #addBtn {
            border-radius: 25px;
        }
        .searchHolder{
            position: fixed;
            top: 3rem;
            right: 1.5rem;
            z-index: 999999;
        }
        .searchHolder input {
            color: #212529;
            background-color: #fff;
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgb(13 72 253 / 55%);
        }
        .searchHolder input:focus {
            box-shadow: 0 0 0 0.25rem rgb(13 72 253 / 55%) !important;
        }
        .markerHolder {
            width: 17rem !important;
            z-index: 99999;
            right: 0;
            position: absolute;
            top: 6rem;
            max-height: 25rem;
            overflow: auto;
        }
        </style>
    </head>
    <body>
        <div class="searchHolder form-group">
            <input id="searchInput" class="form-control" type="text" placeholder="Coffee Shop Search">
        </div>
        <div class="markerHolder">
            <ul class="list-group">
            </ul>
        </div>
        <div id="map"></div>
        <div class="addBtnClass"><button id="addBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop">+</button></div>
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Add New Shop</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <div class="container">
                    <div class="row">
                        <div class="mb-3">
                            <label for="shop_name" class="form-label">Shop Name</label>
                            <input type="text" class="form-control" id="shop_name">
                        </div>
                    </div>
                    <div class="row">
                         <div class="mb-3">
                            <label for="shop_application_date" class="form-label">Date</label>
                            <input type="date" class="form-control" id="shop_application_date">
                        </div>                      
                    </div>
                    <div class="row">
                        <div class="col-auto">
                            <label for="latitude" class="form-label">Latitude</label>
                            <input type="text" class="form-control" id="latitude">
                        </div>
                        <div class="col-auto">
                            <label for="longitude" class="form-label">Longitude</label>
                            <input type="text" class="form-control" id="longitude">
                        </div>                 
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button id="saveBtn" type="button" class="btn btn-primary">Save</button>
                </div>
              </div>
            </div>
          </div>
     </body>
     <script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js'></script>
     <script src="http://cdnjs.cloudflare.com/ajax/libs/leaflet/1.8.0/leaflet.js" integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
     <script src="http://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
     <script>        
        const URL = window.location.href
        console.log("URL:" + URL)
        let markers = []
        let map = L.map('map', {
            minZoom: 2,
            zoom: 2
        })
        function get_all(){
            $.ajax({
                url : URL +'getAll',
                type : 'GET',
                dataType:'json',
                success : function(data) {  
                    map_markers(data)
                },
                error : function(request,error)
                {
                    console.log(request, error)     
                }
            });
        }
        function remove_markers(){
            console.log(map)
            // markers.forEach(marker => {
            //     map.removeLayer(marker)
            // })
            map.eachLayer((layer) => {
                if(layer['_latlng']!=undefined)
                    layer.remove();
            });
            $(".markerHolder ul").empty()
            markers = []
            console.log(map)
        }
        function map_markers (data){ 
            remove_markers()
            var group = []
            data.forEach(object => {                        
                var marker = L.marker([object.Latitude, object.Longitude]).addTo(map)
                marker.bindPopup(object.Name)
                marker.on('click', function(e){
                    this.openPopup()
                    map.setView([object.Latitude, object.Longitude])
                    
                })
                markers.push(marker)
                let template = `<li class="list-group-item"><div class="row">Data</div><span>today</span></li>`
                $(".markerHolder ul").append(`<li id="` + "id" + object.index + `" class="list-group-item"><div class="row">`+ object.Name +`</div><span>` + object.application_date + `</span></li>`)
                $("#id" + object.index).on('click', function(e){
                    console.log('open a popup')
                    marker.openPopup()
                })
            })
            group = new L.featureGroup(markers)
            map.fitBounds(group.getBounds().pad(Math.sqrt(2) / 2))
        }

        $(document).ready(function(){
            L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '© OpenStreetMap'
            }).addTo(map);
            var popupMaster = L.popup({
                closeOnClick: false,
                autoClose: false,
                closeButton: false
            })
            $("#searchInput").keyup(function(){
                markers = []
                var search = $(this).val()
                console.log(markers)
                $.ajax({
                    url :  URL +'search' + "?searchValue=" + search,
                    type : 'GET',
                    dataType:'json',
                    success : function(data) {  
                        map_markers(data)
                    },
                    error : function(request,error)
                    {
                        console.log(request, error)     
                    }
                })
            })
            get_all()
            $('#saveBtn').click(function(){
                var name = $("#shop_name").val()
                var application_date = $("#shop_application_date").val()
                var latitude = $("#latitude").val()
                var longitude = $("#longitude").val()
                var data = {"Name":name,'Latitude': latitude, 'Longitude': longitude, 'application_date':application_date}
                // data = JSON.stringify(data)
                console.log(data)
                $.ajax({
                    url :  URL +'add',
                    type : 'GET',
                    dataType:'json',
                    contentType: "application/json",
                    data: JSON.stringify(data),
                    success : function(data) { 
                        get_all()
                        $('#staticBackdrop').modal('hide');
                        $("#shop_name").val("")
                        $("#shop_type option:selected").val("")
                        $("#latitude").val("")
                        $("#longitude").val("")
                    },
                    error : function(request,error)
                    {
                        console.log(request, error)     
                    }
                })
            })
        })         
     </script>
</html>