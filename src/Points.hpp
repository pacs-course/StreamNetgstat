#ifndef PACSPROJECT_POINTS_HPP
#define PACSPROJECT_POINTS_HPP

#include <iostream>
#include <vector>
#include <map>
#include <Eigen/Dense>
#include "Point.hpp"
#include "StreamSegment.hpp"
//#include "Helpers.hpp"

class Points {

private:
  std::vector<Point> points;
  unsigned int n;
  Eigen::MatrixXi flowMat;
  Eigen::MatrixXd distHydro;
  Eigen::MatrixXd distGeo;

public:
  Points() = default;
  Points(const std::vector<Point>& p);

  const unsigned int getN() const {return n;};
  const Eigen::MatrixXi& getFlowMat() const {return flowMat;};
  const Eigen::MatrixXd& getDistHydro() const {return distHydro;};
  const Eigen::MatrixXd& getDistGeo() const {return distGeo;};
  const std::vector<Point>& getPoints() const {return points;};

  void setPoints(const std::vector<Point>& p);


  void computeDistances(const std::map<std::string, StreamSegment>& segments);

};


#endif //PACSPROJECT_POINTS_HPP