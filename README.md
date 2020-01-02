# FeaturePointDetection_modWS
this is a method to detect feature points on 2D images; we use it to detect stained synapses for live cell imaging and antibody staining as well

<ol>  <li>Edge Filtering </li> 
   Application of a Sobel Filter to get edges indicating the perimeters od synapses
<li>  Dilatation and flood fill operation </li>
<li> get pixel coordinates of each regions </li>
<li> modified <strong><em>watershed method</strong></em> </li>
<ul>
<li> select one region segmented before </li>
<li> feature points detection background is created by filling an adequate sized zero matrix with that region
<li> determin centroids inside that region (maximum based, wo threshold) </li>
<li> centroids are used as markers for watershed method </li>
<li> inverted watershed operation (from maximum to minimum) finds the boundaries </li>
     boundaries are set as soon as a pixel linked to one centroid meets at least one pixel linked to another centroid <br>
     boundaries are als set when the zero space is reached (out of region) <br>
</ul>
<li> regions under a minimum area are discarded </li>

</ol>
