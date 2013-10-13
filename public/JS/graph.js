<script type="text/javascript">

var wheresDad = new Array();
var toggleMEbitch = false;
var breakout = false;
var count = 0;
	
var m = [20, 150, 20, 150],
    w = 1280 - m[1] - m[3],
    h = 800 - m[0] - m[2],
    i = 0
    ;

var tree = d3.layout.tree()
    .size([h, w]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

var vis = d3.select("#body").append("svg:svg")
    .attr("width", w + m[1] + m[3])
    .attr("height", h + m[0] + m[2])
  .append("svg:g")
    .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

	
var linksURL = "link.json";
var pageURL = "page.json";
var near = "nearest.json";

var toWord = "AfghanistanMilitary";
var fromWord = "Wikipedia";

var res = "";
var root = new Object();
var page;
var link;
//$.getJSON(pageURL).done(function(data)
//{
//	page = data;
	//console.log(result[0]);
//});


$.getJSON(near).done(function(data) {
	page = data.pages;
	link = data.links;
	
	console.log(page);
	
	
	
	root.name = fromWord;
	root.children = new Array();
	
	for(var i = 0; i < link.length; i++)
	{
		//var current = i;
		var id = new Object();
		
		var origID = link[i].from_id;
		var result = $.grep(page, function(e){ return e.id == link[i].from_id; });

		id.name = result[0].title;
		id.children = new Array();
		
		var resultTO = $.grep(page, function(e){ return e.id == link[i].to_id; });
		
		var to1 = new Object();
		to1.name = resultTO[0].title;
		id.children.push(to1);
		
		
		while(i+1 < link.length && origID == link[i+1].from_id)
		{
			var resultNEXT = $.grep(page, function(e){ return e.id == link[i+1].to_id; });

			var to = new Object();
			to.name = resultNEXT[0].title;
			id.children.push(to);
			i++;
		}
		
		root.children.push(id);
		//rootID.children.push(uniqueFROM);
	}
	
	console.log(root);
	//res = JSON.stringify(rootID);
	//console.log(res);
	
	
	
	
	
//d3.json("flare.json", function(json) {
 // console.log(json);
  //var root = rootID;
  root.x0 = h / 2;
  root.y0 = 0;
  root.bold = false;

 
  // Initialize the display to show a few nodes.
  //root.children.forEach(hide);
  hide(root);
  console.log(root);
  //toggle(root);
  
  
	turnOn(root);
  console.log(root);
  //toggle(root.children[1]);
//  toggle(root.children[1].children[2]);
 // toggle(root.children[9]);
//  toggle(root.children[9].children[0]);

  update(root);
//});
});
	
 function toggleAll(d) {
	if( d != null && d.name == toWord && breakout == false )
	{
		breakout = true;
		d.bold = true;
		count++;
		//console.log(count + " " + breakout);
	}
	if ( d != null && d._children && breakout == false) {
	 // console.log(d._children);
	 // console.log(include(d.children, "MergeEdge"));
	  d._children.forEach(toggleAll);
	  
	}
  }
  
  function include(arr,obj) {
    return (arr.indexOf(obj) != -1);
}

  function hide(d) {
    if (d.children) {
      d.children.forEach(hide);
      toggle(d);
    }
  }

  function turnOn(d)
{
	toggleAll(d)
	if(breakout == true && d != null)
	{
		toggle(d);
		breakout = false;
		if(d.children)
			d.children.forEach(turnOn);
	}
}


function logchild(d)
{	
	if(d.name == "MergeEdge")
	{
		toggleMEbitch = true;
		//console.log(d)
	}
	else toggleMEbitch = false;
}

function update(source) {
  var duration = d3.event && d3.event.altKey ? 5000 : 500;

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse();

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 180; });

  // Update the nodes…
  var node = vis.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("svg:g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", function(d) { toggle(d); update(d); });

  nodeEnter.append("svg:circle")
      .attr("r", 1e-6)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

		  nodeEnter.append("svg:text")
		  .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
		  .attr("dy", ".35em")
		  .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
		  .text(function(d) {return d.name; } )
		  .style("fill-opacity", 1e-6)
		  .style("font-weight", function(d) { return d.name == toWord || d.name == fromWord ? "bold" : "regular"; })
		  .style("font-size", function(d) { return d.name == toWord  || d.name == fromWord ? "25px" : "11px"; });

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

  nodeUpdate.select("circle")
      .attr("r", 4.5)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

  nodeUpdate.select("text")
      .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

  nodeExit.select("circle")
      .attr("r", 1e-6);

  nodeExit.select("text")
      .style("fill-opacity", 1e-6);

  // Update the links…
  var link = vis.selectAll("path.link")
      .data(tree.links(nodes), function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("svg:path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      })
    .transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children.
function toggle(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
}

    </script>