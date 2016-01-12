package org.georchestra.atlas;


import org.apache.camel.Exchange;
import org.apache.camel.Handler;

import org.apache.camel.converter.stream.InputStreamCache;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONTokener;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


public class CamelPopulatePropertiesComponent {

    private String toString(InputStreamCache property) throws IOException {

        property.reset();
        BufferedReader reader = new BufferedReader(new InputStreamReader(property));

        StringBuilder rawString = new StringBuilder();
        String line;
        while((line = reader.readLine()) != null)
            rawString.append(line);
        return rawString.toString();
    }


    /**
     * Generate following key in exchange properties :
     *  * layers : List of all layers in print request (feature layer and base layers)
     *  * legendURL : URL to download legend
     */
    @Handler
    public void merge(Exchange ex) throws JSONException, IOException {

        InputStreamCache rawJson = ex.getProperty("rawJson", InputStreamCache.class);
        JSONObject jobSpec = new JSONObject(new JSONTokener(toString(rawJson)));

        JSONObject featureLayer = (JSONObject) jobSpec.get("featureLayer");
        JSONArray baseLayers = (JSONArray) jobSpec.get("baseLayers");

        JSONArray layers = new JSONArray();
        layers.put(featureLayer);

        for(int i = 0; i < baseLayers.length();i++)
            layers.put(baseLayers.get(i));

        ex.setProperty("layers",layers.toString());


        String legendURL = featureLayer.getString("baseURL");
        legendURL += "?SERVICE=WMS";
        legendURL += "&VERSION=" + featureLayer.getString("version");
        legendURL += "&REQUEST=GetLegendGraphic&FORMAT=image/png&TRANSPARENT=true";
        legendURL += "&LAYER=" + featureLayer.getString("layer");

        ex.setProperty("legendURL", legendURL);

    }
}
